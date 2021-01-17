import cv2 as cv
import numpy as np
import os
from scipy import misc
import glob
import imutils

for i in range(20):
    temp_found = None

    filename = './images/images/images/Pic%d.bmp'%(i+1)
    img_rgb = misc.imread(filename)
    # img_rgb = cv.Canny(img_rgb, 10, 25)
    img_rgb_resized = imutils.resize(img_rgb, width=int(img_rgb.shape[1] * 0.5))

    list = ['images/templates/Pat01.bmp', 'images/templates/Pat02.bmp', 'images/templates/Pat03.bmp',
            'images/templates/Pat04.bmp', 'images/templates/Pat05.bmp']
    for image in list:
        template = misc.imread(image)
        resized_tmp = imutils.resize(template, width=int(template.shape[1] * 0.5))
        w, h = resized_tmp.shape[:2]
        res = cv.matchTemplate(img_rgb_resized, resized_tmp, cv.TM_SQDIFF)
        (_, val_max, _, loc_max) = cv.minMaxLoc(res)
        top_left = loc_max
        bottom_right = (top_left[0] + w, top_left[1] + h)
        if temp_found is None or val_max > temp_found[0]:
            temp_found = (val_max, loc_max, top_left, bottom_right, w, h)


    (_, loc_max, top_left, bottom_right, w, h) = temp_found

    # Draw rectangle around the template
    cv.rectangle(img_rgb_resized, top_left, bottom_right, (153, 22, 0), 4)
    cv.imshow('Template Found', img_rgb_resized)
    filename = './images_out/template_matching_result_%d.bmp'%(i+1)
    misc.imsave(filename, img_rgb_resized)

