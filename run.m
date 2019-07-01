path = 'haze_img/';
img = imread([path, 'pic_3.jpg']);
img = double(img)/255;
%img = imresize(img, 0.1);
img = imresize(img, [100 200]);
haze_free_img = Haze_Removal(img, 0.95, 15, 0.0001);
imshow(haze_free_img);