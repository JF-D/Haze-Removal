function haze_free_img = Haze_Removal(img, omega, patch_size, lambda)
[m, n, ~] = size(img);

%% dark channel
pad = floor(patch_size/2);
J_c = min(img, [], 3);
pad_Jc = padarray(J_c, [pad pad], Inf);
J_dark = zeros(m, n);

for i = 1:m
    for j = 1:n
        J_dark(i,j) = min(min(pad_Jc(i:i+patch_size-1, j:j+patch_size-1)));
    end
end

%haze_free_img = uint8(zeros(m, n, 3));
%haze_free_img(:,:,1) = J_dark;
%haze_free_img(:,:,2) = J_dark;
%haze_free_img(:,:,3) = J_dark;
%% Estimating the Atmospheric Light
num_pixels = floor(m*n*0.01);
dark_vec = reshape(J_dark, m*n, 1);
img_vec = reshape(img, m*n, 3);
[~, idx] = sort(dark_vec, 'descend');
A = mean(img_vec(idx(1:num_pixels), :));

%% Estimating the Transmission
A = reshape(A, [1, 1, 3]);
J_c = min(double(img) ./ double(A), [], 3);
pad_Jc = padarray(J_c, [pad pad], Inf);
trans = zeros(m, n);

for i = 1:m
    for j = 1:n
        trans(i,j) = 1 - omega * min(min(pad_Jc(i:i+patch_size-1, j:j+patch_size-1)));
    end
end

%% Soft Matting
L = Laplacian(double(img));
trans = reshape(trans, m*n, 1);
t = (L + lambda * eye(size(L, 1))) \ (lambda * trans);
t = reshape(t, m, n);

%% Recovering the Scene Radiance
A = repmat(A, m, n);
t = repmat(max(t, 0.1), [1, 1, 3]);
J = (img - A) ./ t + A;

haze_free_img = J;
end