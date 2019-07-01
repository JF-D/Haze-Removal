function L = Laplacian(img)
%Laplacian: generate Laplacian of `img(double type)`
%  Input : img(RGB 3-channel image)
%  Output: Laplacian L(using to do soft matting to refine transmission)
[m, n, c] = size(img);

% Local patch/window pad: w_p(1), size: w_k(9)
w_p = 1;
w_k = 9;

% total number of pixels of `L`
tot = w_k * w_k * (m - 2*w_p) * (n - 2*w_p);

indices = reshape(1:m*n, m, n);
idx = ones(1, tot);
idy = ones(1, tot);
Lvec = zeros(1, tot);

cnt = 0;
for j = (1+w_p):(n-w_p)
    for i = (1+w_p):(m-w_p)
        %local patch/window
        window = img(i-w_p:i+w_p, j-w_p:j+w_p, :);
        wnd_vec = reshape(window, w_k, 3);
        
        %mean and covar
        wnd_mean = mean(wnd_vec);
        wnd_norm = wnd_vec - wnd_mean;
        covar = wnd_norm' * wnd_norm / w_k;
        
        %L matrix elements
        mid  = covar + (0.0000001 .* eye(3) ./ w_k);
        % wnd_norm * mid_inv = X => wnd_norm = X * mid 
        % => X = wnd_norm / mid
        %elements = eye(w_k) - (1 + (wnd_norm / mid) * wnd_norm') ./ w_k;
        elements = eye(w_k) - (1 + wnd_norm * inv(mid) * wnd_norm') ./ w_k;
        
        %index combinations
        wnd_id = reshape(indices(i-w_p:i+w_p, j-w_p:j+w_p), 1, w_k);
        wnd_idx = repmat(wnd_id, w_k, 1);
        wnd_idy = wnd_idx';
        
        idx(cnt*(w_k^2)+1:cnt*(w_k^2)+w_k^2) = wnd_idx(:)';
        idy(cnt*(w_k^2)+1:cnt*(w_k^2)+w_k^2) = wnd_idy(:)';
        Lvec(cnt*(w_k^2)+1:cnt*(w_k^2)+w_k^2) = elements(:)';
        cnt = cnt + 1;
    end
end

L = sparse(idx, idy, Lvec, m*n, m*n);
end