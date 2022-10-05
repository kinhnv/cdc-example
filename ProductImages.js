if (ctx.op == 'create') { 
    if (params['after.FileId'] != null) { 
        ctx._source.FileIdImg = [params['after.FileId']]; 
        ctx._source.OrderImg = [params['after.Order']]; 
    } 
} 
else { 
    if (params['before.FileId'] != null) { 
        if (ctx._source.FileIdImg != null) { 
            if (ctx._source.FileIdImg.contains(params['before.FileId'])) { 
                ctx._source.OrderImg.remove(ctx._source.FileIdImg.indexOf(params['before.FileId'])); 
                ctx._source.FileIdImg.remove(ctx._source.FileIdImg.indexOf(params['before.FileId'])); 
            } 
        } 
    } 
    if (params['after.FileId'] != null) { 
        if (ctx._source.FileIdImg != null) { 
            ctx._source.FileIdImg.add(params['after.FileId']); 
            ctx._source.OrderImg.add(params['after.Order']); 
        } 
        else if (params['after.FileId'] != null) { 
            ctx._source.FileIdImg = [params['after.FileId']]; 
            ctx._source.OrderImg = [params['after.Order']]; 
        } 
    } 
}