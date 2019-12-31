function X=trianglin(P1,P2,x1,x2)
    
    % Inputs:
    %   P1 and P2, projection matrices for both images
    %   x1 and x2, image coordinates for both images
    
    % Form A and get the least squares solution from the eigenvector 
    % corresponding to the smallest eigenvalue
    %%-your-code-starts-here-%%
    X = ones(4,1);% replace with your implementation
    e1=[0 -x1(3) x1(2); x1(3) 0 -x1(1); -x1(2) x1(1) 0]*P1;
    e2=[0 -x2(3) x2(2); x2(3) 0 -x2(1); -x2(2) x2(1) 0]*P2;
    Z=[e1; e2];
    
    [M1,V1]=eig(Z'*Z);
    %[M2,V2]=eig(e2);
    minimum1=min(min(V1));
%     minimum2=min(min(V2));
     [x1,y1]=find(V1==minimum1);
%     [x2,y2]=find(V2==minimum2);
     X=M1(:,y1);
%     EV2=M2(:,y2);
%     size(EV1);
    %%-your-code-ends-here-%%
    

end
