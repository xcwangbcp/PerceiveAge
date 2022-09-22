function res = lianxu1(a)
a = [0 ones(1,5)  0 0 1 0 ones(1,10) 0] ;
b = find(a) ;
res = [] ;
n = 1 ; i = 1 ;
while i < length(b)
    j = i+1 ;
    while j <= length(b) &  b(j)==b(j-1)+1 
        n = n + 1 ;
        j = j + 1 ;
    end
    if n >= 3
        res = [res ; b(i),n] ;
    end
    n = 1 ;
    i = j ;
end
x=1