%% plot points
clear all;
load('points.mat','x','y');
figure;hold on;
plot(x,y,'kx');
axis equal

%% m is the number of data points
m=length(x);
% s is the size of the random sample
s=2;
% t is the inlier distance threshold
t=sqrt(3.84)*2;
% e is the expected outlier ratio
e=0.8;
% at least one random sample should be free from outliers with probability p 
p=0.999;
% required number of samples
N_estimated=log(1-p)/log(1-(1-e)^s)

%% RANSAC loop
% First initialize some variables
N=inf;
sample_count=0;
max_inliers=0;
best_line=zeros(3,1);
%
%

while(N>sample_count)
    % Pick two random samples
    a=ceil(m*rand(1));  % sample id 1
    b=ceil(m*rand(1));  % sample id 2
    if a==b %if the same point is drawn twice, must draw again
        continue;
    end
    
    % Determine the line crossing the points with the cross product or
    % points
    
    %%-your-code-starts-here%%
    z=1:130;
    plot(x(a),y(a),'ro');
    plot(x(b),y(b),'ro');
    pnt1=[x(a) y(a) 1]; pnt2=[x(b) y(b) 1];
    lin=cross(pnt1,pnt2);
    al=lin(1); bl=lin(2); cl=lin(3);
    fun=@(x) (-al.*x-cl)./bl;
    %%-your-code-ends-here%%
    
    % Determine the inliers by finding the indices for the line and data
    % point dot products which are less than inlier threshold.
    
    %%-your-code-starts-here%%
    indcs=0;
    inliers=abs(y-fun(x));
    inliers=inliers(inliers <= t);
    for i=1:m
        inl=abs(y(i)-fun(x(i)));
        if inl <= t
            indcs=[indcs i];
        end
    end
    %%-your-code-ends-here%%
    
    % keep the hypothesis giving most inliers so far
    inlier_count=length(inliers);
    if inlier_count>max_inliers
        best_line=lin(:);%was l
    end
    
    % update the estimate of the outlier ratio
    e=1-inlier_count/m;
    % update the estimate for the required number of samples
    N=log(1-p)/log(1-(1-e)^s);
    
    sample_count=sample_count+1;
end
% Least squares fitting to the inliers of the best hypothesis, i.e.
% find the inliers similarly as above but this time for the best line.
%%-your-code-starts-here%%
%al=best_line(1); bl=best_line(2); cl=best_line(3);
%fun=@(x) (-al.*x-cl)./bl;
%y_inliers=fun(x_inliers);
%plot(x,fun(x))
x_inliers=x(indcs(2:length(indcs)));
y_inliers=y(indcs(2:length(indcs)));
inliers=indcs(2:length(indcs));
%%-your-code-ends-here%%
% Fit a line to the given points (non-homogeneous)
l=linefitlsq(x_inliers, y_inliers);

% plot the resulting line and the inliers
k=-l(1)/l(2);
b=-l(3)/l(2);
plot(1:100,k*[1:100]+b,'m-');
plot(x(inliers),y(inliers),'ro');
