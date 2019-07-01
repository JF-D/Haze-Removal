path = 'haze_img/';
dpath = 'haze_free_img/';
imgname = 'pic_8.bmp';
img = imread([path, imgname]);
haze_free_img = Haze_Removal(img, 0.95, 15, 0.0001);

imwrite(haze_free_img, [dpath, imgname]);
figure;
imshow(haze_free_img);