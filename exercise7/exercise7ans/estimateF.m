function [ F ] = estimateF(x1,x2)
    % Input points are stacked column vectors, i.e. the row id corresponds
    % to the point id.
    
    % Use x1 and c2 to construct equation for homogeneous linear system
    % Each point correspondence gives a row vector described in the exercise sheet,
    % stack these to form a matrix used for estimating F.
    %%-your-code-starts-here-%%
    px1=x1(1,:)'; py1=x1(2,:)';
    px2=x2(1,:)'; py2=x2(2,:)';
    A=[px2.*px1 px2.*py1 px2 py2.*px1 py2.*py1 py2 px1 py1 ones(11,1)];
    %%-your-code-ends-here-%%
    
    % Calculate SVD from our matrix above.
    % Extract fundamental matrix from the column of V corresponding to
    % smallest singular value.
    %%-your-code-starts-here-%%
    [~,S,V]=svd(A);
    fmat=reshape(V(:,9),[3 3])';
    %%-your-code-ends-here-%%
    
    % Enforce constraint that fundamental matrix has rank 2 by performing
    % svd and then reconstructing with only the two largest singular values.
    % Reconstruction for matrix M:
    % M = U*S*V'
    % Where S is a diagonal matrix containing the singular values
    %%-your-code-starts-here-%%
    [U,S,V]=svd(fmat);
    F = U(:, 1) * S(1,1) * transpose(V(:, 1)) + U(:, 2) * S(2,2) * transpose(V(:, 2));
    %%-your-code-ends-here-%%
end

