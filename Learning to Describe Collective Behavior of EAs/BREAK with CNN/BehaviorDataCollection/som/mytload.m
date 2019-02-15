function  hits = mytload(timename, inputhome, Map)
     templen = length(timename);
     hits = zeros(prod(Map.map_size), templen);
     strload = load([inputhome '/'  timename{1}]);
     if isfield(strload, 'pop')
        for i = 1:templen
            clear str;
                str =  load([inputhome '/' timename{i}]);
%                 oridata = pop;
%                hits(:,i) = gethit(Map, oridata);
        end
  	elseif isfield(strload, 'x')
        for i = 1:templen
              clear str;  str = load([inputhome' '/' timename{i}]);
%                oridata = x;
%                hits(:,i) = gethit(Map, oridata);
        end
     elseif isfield(strload, 'foods')
        for i =1:templen
             clear str;      str = load([inputhome '/' timename{i}]);
%                 oridata = foods;
%                 hits(:,i) = gethit(Map, oridata);
        end
    end
end