do_replace_checksum() {
	sed -i 's,be8be39fdbc6e60e94fa7870b280707069b5b81a,32b145f525a8308d7ab1c09388b2e288312d8eba,g' ${S}/cmake/deps.txt
}
addtask replace_checksum before do_generate_toolchain_file after do_patch

