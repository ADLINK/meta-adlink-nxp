# ex:ts=4:sw=4:sts=4:et
# -*- tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*-
#
# Copyright (c) 2020, TechNexion.
# All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# DESCRIPTION
# This implements the 'datafs' source plugin class for 'wic'
#
# AUTHORS
# Po Cheng <po.cheng@technexion.com>
#

import logging
import os
import shutil
import sys

from oe.path import copyhardlinktree
from wic import WicError
from wic.pluginbase import SourcePlugin
from wic.misc import exec_cmd, exec_native_cmd, get_bitbake_var
from wic.filemap import sparse_copy

logger = logging.getLogger('wic')

class DatafsPlugin(SourcePlugin):
    """
    Populate partition content from a datafs directory.
    """

    name = 'datafs'

    @staticmethod
    def do_image_label(fstype, dst, label):
        if fstype.startswith('ext'):
            cmd = 'tune2fs -L %s %s' % (label, dst)
        elif fstype in ('msdos', 'vfat'):
            cmd = 'dosfslabel %s %s' % (dst, label)
        elif fstype == 'btrfs':
            cmd = 'btrfs filesystem label %s %s' % (dst, label)
        elif fstype == 'swap':
            cmd = 'mkswap -L %s %s' % (label, dst)
        elif fstype == 'squashfs':
            raise WicError("It's not possible to update a squashfs "
                           "filesystem label '%s'" % (label))
        else:
            raise WicError("Cannot update filesystem label: "
                           "Unknown fstype: '%s'" % (fstype))
        exec_cmd(cmd)

    @classmethod
    def do_prepare_partition(cls, part, source_params, cr, cr_workdir,
                             oe_builddir, bootimg_dir, kernel_dir,
                             krootfs_dir, native_sysroot):
        """
        Called to do the actual content population for a partition i.e. it
        'prepares' the partition to be incorporated into the image.
        In this case, prepare content for data partition that mounts to a
        specific directory in rootfs.
        """
        # Passed in Parameters (from Partition(object).prepare() entry point)
        #   part => Partition(object).instance
        #   source_params => srcparams_dict
        #   cr => creator
        #   cr_workdir => cr_workdir
        #   oe_builddir => oe_builddir
        #   bootimg_dir => bootimg_dir
        #   kernel_dir => kernel_dir
        #   krootfs_dir => krootfs_dir
        #   native_sysroot => native_sysroot
        #
        #   original wic do_create command entry point: DirectPlugin(ImagerPlugin).do_create()->
        #        try:
        #          self.create()
        #          self.assemble()
        #          self.finalize()
        #          self.print_info()
        #        finally:
        #          self.cleanup()
        #
        #   direct.py's PartitionedImage(object).create()->
        #        self._image.prepare(...) i.e. loop all partitions in wks file and prepare the partition
        #        self._image.layout_partitions(...) i.e. calculate positions of all partitions
        #        self._image.create() -> exec_native_cmd() i.e. call parted cmd to generate partition
        #
        #   partition.py's class Partition(object).prepare()->
        #        plugin.do_configure_partition(...)
        #        plugin.do_stage_partition(...)
        #        plugin.do_prepare_partition(...)
        #        plugin.do_post_partition(...)
        #

        # must find the datafs partition image specified by --sourceparams from deployed directory
        if not kernel_dir:
            kernel_dir = get_bitbake_var("DEPLOY_DIR_IMAGE")
            if not kernel_dir:
                raise WicError("Couldn't find DEPLOY_DIR_IMAGE, exiting")

        if 'file' not in source_params:
            raise WicError("No file specified")

        # Note: We only care about TN_PARTITION_IMAGE (from image_type_tn.bbclass)
        #       or TN_DOCKER_PARTITION_IMAGE (from docker-disk.inc/pico-imx8mm.conf)
        #       or anyother PARTITION_IMAGE that we want to write to the additional data partition
        #       which is used in wic/tn-imx8-imxboot-rootfs-container.wks.in
        #       and this src image was created with mkfs command:
        # mkfs.ext4 -E lazy_itable_init=0,lazy_journal_init=0 -i 8192 -d ${DATA_VOLUME}/docker -F ${BUILD}/${PARTITION_IMAGE}
        src = os.path.join(kernel_dir, source_params['file'])
        # prepare the dst partition image first
        dst = os.path.join(cr_workdir, "fs_{}.{}.{}".format(part.label, part.lineno, part.fstype))
        logger.info("datafs src: {}\ndatafs dst: {}\n".format(src, dst))
        if os.path.isfile(dst):
            os.remove(dst)

        # copy src to dst in binary
        if 'skip' in source_params:
            sparse_copy(src, dst, skip=int(source_params['skip']))
        else:
            sparse_copy(src, dst)

        # check the ext4 file system on the dst file
        mkfs_cmd = "fsck.{} -pvfD {}".format(part.fstype, dst)
        exec_native_cmd(mkfs_cmd, native_sysroot)

        # get the size in the right units for kickstart (kB)
        du_cmd = "du -Lbks {}".format(dst)
        out = exec_cmd(du_cmd)
        filesize = int(out.split()[0])
        if filesize > part.size:
            part.size = filesize

        # update the partition label
        if part.label:
            DatafsPlugin.do_image_label(part.fstype, dst, part.label)

        part.source_file = dst
