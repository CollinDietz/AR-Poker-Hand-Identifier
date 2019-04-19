#use python2.7

#designed to take what we have from generate-data.py (a directory of images, and their xml data), convert it into a turicreate sframe and train on them

import xml.etree.ElementTree as ET
from pprint import pprint
import os
from glob import glob
import pandas as pd
import turicreate as tc
import mxnet

def get_image_data(xml_file): #converts xml data to a list of dictionaries
    tree = ET.parse(xml_file)
    root = tree.getroot()
    dict_list = []
    img_dict = {}
    idx = 0
    for info in root.findall('object'):
        name = info.find('name').text
        bndbox = info.find('bndbox')
        coords = []
        for num in bndbox:
            coords.append(int(num.text))
        width = coords[2] - coords[0]
        height = coords[3] - coords[1]
        x = (coords[0] + coords[2]) / 2
        y = (coords[1] + coords[3]) / 2
        img_dict[idx] ={'coordinates': {'height': height, 'width': width, "x": x, "y": y}, 'label': name}
        idx += 1


    for key in img_dict:
        dict_list.append(img_dict[key])
    return dict_list

print "Loading images..."
images_sf = tc.image_analysis.load_images("5000jpg", with_path = True) #load into SF


list_of_annotations = []
print "Loading annotation data..."
for file in sorted(glob("5000xml"+"/*.xml")):
    list_of_annotations.append(get_image_data(file))

annotations_sarray = tc.SArray(list_of_annotations) #create SArray of annotations so that we can add it to the SFrame


data = images_sf.add_column(annotations_sarray,"annotations")

model = tc.object_detector.create(data, max_iterations=7000, feature='image', annotations='annotations') #train model. loss stops decreasing around 4500 iterations

model.save("CardDetector2.1.model") #save model to current directory

model.export_coreml('CardDetector2.1.mlmodel') #export model to coreML format
