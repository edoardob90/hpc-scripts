function onejob(script_index)

unixcmd=sprintf('%s%d%s', 'sed -n "', script_index, 'p" fileindex.txt');
[status,input_file]=unix(unixcmd);

disp(input_file)

end
