function [ class, centroid ] = mykmedoids( pixels, K )
%
% Your goal of this assignment is implementing your own K-medoids.
% Please refer to the instructions carefully, and we encourage you to
% consult with other resources about this algorithm on the web.
%
% Input:
%     pixels: data set. Each row contains one data point. For image
%     dataset, it contains 3 columns, each column corresponding to Red,
%     Green, and Blue component.
%
%     K: the number of desired clusters. Too high value of K may result in
%     empty cluster error. Then, you need to reduce it.
%
% Output:
%     class: the class assignment of each data point in pixels. The
%     assignment should be 1, 2, 3, etc. For K = 5, for example, each cell
%     of class should be either 1, 2, 3, 4, or 5. The output should be a
%     column vector with size(pixels, 1) elements.
%
%     centroid: the location of K centroids in your result. With images,
%     each centroid corresponds to the representative color of each
%     cluster. The output should be a matrix with size(pixels, 1) rows and
%     3 columns. The range of values should be [0, 255].
%     
%
% You may run the following line, then you can see what should be done.
% For submission, you need to code your own implementation without using
% the kmeans matlab function directly. That is, you need to comment it out.

	%[class, centroid] = kmeans(pixels, K);
    
rand('seed', sum(clock));
x = pixels';
dim = size(x,1);
m = size(x,2);
cno = K;
c = 6*rand(dim, cno); 
c_old = c + 10;

%figure; 
i = 1; 
% check whether the cluster centers still change; 
%tic
while (sum(sum(abs(c - c_old))) > 1e-6)
    %norm(c-c_old, 'fro')
    fprintf(1, '--iteration %d \n', i);
    
    % record previous c; 
    c_old = c; 
    
    % assign data points to current cluster; 
    for j = 1:m % loop through data points; 
        tmp_distance = zeros(1, cno); 
        for k = 1:cno % through centers; 
            tmp_distance(k) = sum(abs(x(:,j) - c(:,k))); % norm(x(:,j) - c(:,k)); 
        end
        [~,k_star] = min(tmp_distance); % ~ ignores the first argument; 
        P(j, :) = zeros(1, cno); 
        P(j, k_star) = 1; 
    end
        
    % adjust the cluster centers according to current assignment;
    obj = 0; 
    for k = 1:cno
        idx = find(P(:,k)>0); 
        nopoints = length(idx);  
        if (nopoints == 0) 
            % a cener has never been assigned a data point; 
            % re-initialize the center; 
            c(:,k) = rand(dim,1);  
        else
            % equivalent to sum(x(:,idx), 2) ./ nopoints;
            objj = sum(sum(abs(x(:,idx) - repmat(c(:,k), 1, nopoints))));
            %center = idx(1);
            for h=1:nopoints
                term = sum(sum(abs(x(:,idx) - repmat(x(:,idx(h)), 1, nopoints))));
                if(term < objj)
                    objj = term;
                    c(:,k) = x(:,idx(h));
                end
            end
            %c(:,k) = x(:,center);
        end
        obj = obj + sum(sum(abs(x(:,idx) - repmat(c(:,k), 1, nopoints))));
        
    end    
    i = i + 1;     
end

centroid = c';

for i = 1:m
    class(i) = find(P(i,:)>0);
end

end