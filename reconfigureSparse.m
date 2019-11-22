lbKa = load("lbkappaSolver_A.txt");
bVec_load = load("lbkappaSolver_bVec_copy.txt");
bVec = bVec_load(:,3:end-2);
% 
xVec_load = load("lbkappaSolver_xVec_copy.txt");
xVec = xVec_load(:,3:end-2);

[nx,ny] = size(xVec);
Avals_simplified = -99*ones(nx,ny,5);
Avals = zeros(length(lbKa),1);
indsI = Avals;
indsJ = Avals;
index = 1;
EastInd = 1;
WestInd = 2;
CenterInd = 3;
NorthInd = 4;
SouthInd = 5;


for i = 1:length(lbKa)
    ival = lbKa(i,1);
    jval = lbKa(i,2);
    Aval = lbKa(i,3);
    
    ival_j = floor(ival/2048) - 2;
    ival_i = mod(ival,2048);
    
    jval_j = floor(jval/2048) - 2;
    jval_i = mod(jval,2048);
    
    if(ival_i >= 2000 || ival_j < 0 || ival_j > 199)
        continue;
    end
    
    if(jval_j < 0 || jval_j > 199)
        continue;
        %bVec(ival_i+1,ival_j+1) = bVec(ival_i+1,ival_j+1) - Aval*xVec(ival_i+1,ival_j+1);
    end
    if(jval_i >= 2000)
        bVec(ival_i+1,ival_j+1) = bVec(ival_i+1,ival_j+1) - Aval*xVec(ival_i+1,ival_j+1);
        continue;
    end
    
    ival = (ival_i)*200 + ival_j + 1;
    jval = (jval_i)*200 + jval_j + 1;
    Avals(index) = Aval;
    indsI(index) = jval;%ival
    indsJ(index) = ival;%jval
    if((ival_i > jval_i && ival_i ~= 1999) || (ival_i == 0 && ival_j == 1999))
        Avals_simplified(ival_i+1,ival_j+1,WestInd) = Aval;
    end
    if((ival_i < jval_i && ival_i ~= 0) || (ival_i == 1999 && ival_j == 0))
        Avals_simplified(ival_i+1,ival_j+1,EastInd) = Aval;
    end
    if((ival_j > jval_j))
        Avals_simplified(ival_i+1,ival_j+1,SouthInd) = Aval;
    end
    if((ival_j < jval_j))
        Avals_simplified(ival_i+1,ival_j+1,NorthInd) = Aval;
    end
    if(ival_i == jval_i && ival_j == jval_j)
        Avals_simplified(ival_i+1,ival_j+1,CenterInd) = Aval;
    end  
    
    
    index = index+1;
end
if(index < length(Avals))
    Avals(index:end) = [];
    indsJ(index:end) = [];
    indsI(index:end) = [];
end
Asparse = sparse(indsI, indsJ, Avals);


        
        
        
    
    
    