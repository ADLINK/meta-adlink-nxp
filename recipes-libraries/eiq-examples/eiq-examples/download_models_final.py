#
# Copyright 2020-2022 NXP
#
# SPDX-License-Identifier: Apache-2.0
#

import requests
import os
import tarfile
import shutil

def download_file(url, path, retry=3):
    if (os.path.exists(path)):
        os.unlink(path)
 
    print("Download file from", url)
    while (retry != 0):
        try:
            req = requests.get(url)
            break
        except Exception:
            retry -= 1
            print("Failed to download file from", url, "Retrying")
    with open(path, "wb") as f:
        f.write(req.content)

def decompress(path, model_dir):
    tar = tarfile.open(path, "r:gz")
    file_names = tar.getnames()
    for file_name in file_names:
        tar.extract(file_name, model_dir)
    tar.close()

def download_all_models(model_dir, vela_dir):
    os.makedirs(model_dir, exist_ok=True)
    os.makedirs(vela_dir, exist_ok=True)

    #Download gesture models
    #https://github.com/PINTO0309/PINTO_model_zoo
    #url = 'https://drive.google.com/uc?export=download&&id=1yjWyXsac5CbGWYuHWYhhnr_9cAwg3uNI'
    #path = os.path.join(model_dir, 'gesture_models.tar.gz')
    #download_file(url, path)
    #decompress(path, model_dir)

    #Download face recognition models
    #https://github.com/imuncle/yoloface-50k
    url = 'https://raw.githubusercontent.com/imuncle/yoloface-50k/main/tflite/yoloface_int8.tflite'
    path = os.path.join(model_dir, 'yoloface_int8.tflite')
    download_file(url, path)

    #https://github.com/shubham0204/FaceRecognition_With_FaceNet_Android
    url = 'https://raw.githubusercontent.com/shubham0204/FaceRecognition_With_FaceNet_Android/master/app/src/main/assets/facenet_512_int_quantized.tflite'
    path = os.path.join(model_dir, 'facenet_512_int_quantized.tflite')
    download_file(url, path)

    #Download object detection model
    #https://www.tensorflow.org/
    #url = 'https://storage.googleapis.com/tfhub-lite-models/tensorflow/lite-model/ssd_mobilenet_v1/1/metadata/2.tflite'
    #path = os.path.join(model_dir, 'ssd_mobilenet_v1_quant.tflite')
    #download_file(url, path)

    #Download image classification model
    #https://www.tensorflow.org/
    url = 'http://download.tensorflow.org/models/mobilenet_v1_2018_08_02/mobilenet_v1_1.0_224_quant.tgz'
    path = os.path.join(model_dir, 'mobilenet_v1_1.0_224_quant.tgz')
    download_file(url, path)
    decompress(path, model_dir)

    #Download dms models
    #https://github.com/PINTO0309/PINTO_model_zoo
    #url = "https://drive.google.com/uc?export=download&id=1YEAgUuHyJ7_fTY9XyDaALDidM6Sbzhd8"
    #path = os.path.join(model_dir, 'dms_face_detection.tar.gz')
    #download_file(url, path)
    #decompress(path, model_dir)

    #https://github.com/PINTO0309/PINTO_model_zoo
    #url = "https://drive.google.com/uc?export=download&id=1lwnWACdV1zWlJPW11OhFN1XFbzEsDu1K"
    #path = os.path.join(model_dir, 'dms_face_landmark.tar.gz')
    #download_file(url, path)
    #decompress(path, model_dir)

    #https://github.com/PINTO0309/PINTO_model_zoo
    #url = "https://drive.google.com/uc?export=download&confirm=yTib&id=1VHM41B8bSr07loNtHlTbXr89670w3H9W"
    #path = os.path.join(model_dir, 'dms_iris_landmark.tar.gz')
    #download_file(url, path)
    #decompress(path, model_dir)
    
    #shutil.copyfile("models/saved_model_64x64/model_integer_quant.tflite", "models/iris_landmark_quant.tflite")

def convert_model(model_dir, vela_dir):
    for name in os.listdir(model_dir):
        if name.endswith(".tflite"):
            print('Converting', name)
            model = os.path.join(model_dir, name)
            os.system('vela ' + model + " --output-dir " + vela_dir)

model_dir = 'models'
vela_dir = 'vela_models'
download_all_models(model_dir, vela_dir)
convert_model(model_dir, vela_dir)
