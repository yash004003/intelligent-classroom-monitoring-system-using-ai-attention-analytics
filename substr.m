function outstr= substr(str, offset, len)

% Check number of input arguments.
error(nargchk(2, 3, nargin));

n= length(str);

% Calculate starting index of substring:

if offset < 0
   lb= offset + n + 1;   % offset from end of string
   lb= max(lb, 1);
elseif offset == 0
   lb= 1;
else
   lb= offset;
end

% Calculate ending index of substring:

if nargin == 2           % substr(str, offset)
   ub= n;

else                     % substr(str, offset, len)
   if len >= 0
      ub = lb + len - 1;
   else
      ub = n + len;
   end
   ub= min(ub, n);
end

% Extract substring:

outstr= str(lb : ub);

end
