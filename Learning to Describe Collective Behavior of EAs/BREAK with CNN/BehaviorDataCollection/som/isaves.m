%function isaves(savedatapath, del_rep_data, saveindexpath, del_rep_index)
function isaves(savedatapath, hits)

  save( [savedatapath, '/', 'hits'], 'hits');
  %save([saveindexpath, '/', 'del_rep_index'], 'del_rep_index');

end

