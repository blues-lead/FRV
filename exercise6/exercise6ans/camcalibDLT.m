function P=camcalibDLT(Xworld,Xim)
    % Inputs: 
    %   Xworld, world coordinates in the form (id, coordinates)
    %   Xim, image coordinates in the form (id, coordinates)
    % Create the matrix A 
    %%-your-code-starts-here-%%
    %A=[zeros(1,3) Xworld(1,:)' -yX1]
    for i=1:2:7
        A(i,:)=[zeros(1,4) Xworld(i,:) -Xim(i,2)*Xworld(i,:)];
        A(i+1,:)=[Xworld(i,:) zeros(1,4) -Xim(i,1)*Xworld(i,:)];
    end
    %%-your-code-ends-here-%%
    
    % Perform homogeneous least squares fitting,
    % the best solution is given by the eigenvector of 
    % A.T*A with the smallest eigenvalue.
    %%-your-code-starts-here-%%
    [M, V]=eig(A'*A);
    minimum=min(min(V));
    [x,y]=find(V==minimum);
    ev=M(:,y);
    size(ev);
    %%-your-code-ends-here-%%

    % Reshape the eigenvector into a projection matrix P
    P=(reshape(ev,4,3))' % uncomment this
    %P = [1 0 0 0;0 1 0 0;0 0 1 0];  % remove this

end