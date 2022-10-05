if (ctx.op == 'create') { 
    if (params['after.FileId'] != null) { 
        ctx._source.FileIdImg360 = [params['after.FileId']]; 
        ctx._source.Caption = [(params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Caption'] == null ? '' : params['after.Caption'])]; 
        ctx._source.Top = [(params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Top'] == null ? '' : Integer.toString(params['after.Top']))]; 
        ctx._source.Right = [(params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Right'] == null ? '' : Integer.toString(params['after.Right']))]; 
        ctx._source.Bottom = [(params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Bottom'] == null ? '' : Integer.toString(params['after.Bottom']))]; 
        ctx._source.Left = [(params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Left'] == null ? '' : Integer.toString(params['after.Left']))]; 
        ctx._source.OrderImg360 = [params['after.Order']]; 
    } 
} 
else { 
    if (params['before.FileId'] != null) { 
        if (ctx._source.FileIdImg360 != null) { 
            if (ctx._source.FileIdImg360.contains(params['before.FileId'])) { 
                ctx._source.Caption.remove(ctx._source.FileIdImg360.indexOf(params['before.FileId'])); 
                ctx._source.Top.remove(ctx._source.FileIdImg360.indexOf(params['before.FileId'])); 
                ctx._source.Right.remove(ctx._source.FileIdImg360.indexOf(params['before.FileId'])); 
                ctx._source.Bottom.remove(ctx._source.FileIdImg360.indexOf(params['before.FileId'])); 
                ctx._source.Left.remove(ctx._source.FileIdImg360.indexOf(params['before.FileId'])); 
                ctx._source.OrderImg360.remove(ctx._source.FileIdImg360.indexOf(params['before.FileId'])); 
                ctx._source.FileIdImg360.remove(ctx._source.FileIdImg360.indexOf(params['before.FileId'])); 
            } 
        } 
    } 
    if (params['after.FileId'] != null) { 
        if (ctx._source.FileIdImg360 != null) { 
            ctx._source.FileIdImg360.add(params['after.FileId']); 
            ctx._source.Caption.add((params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Caption'] == null ? '' : params['after.Caption'])); 
            ctx._source.Top.add((params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Top'] == null ? '' : Integer.toString(params['after.Top']))); 
            ctx._source.Right.add((params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Right'] == null ? '' : Integer.toString(params['after.Right']))); 
            ctx._source.Bottom.add((params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Bottom'] == null ? '' : Integer.toString(params['after.Bottom']))); 
            ctx._source.Left.add((params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Left'] == null ? '' : Integer.toString(params['after.Left']))); 
            ctx._source.OrderImg360.add(params['after.Order']); 
        } 
        else if (params['after.FileId'] != null) { 
            ctx._source.FileIdImg360 = [params['after.FileId']]; 
            ctx._source.Caption = [(params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Caption'] == null ? '' : params['after.Caption'])]; 
            ctx._source.Top = [(params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Top'] == null ? '' : Integer.toString(params['after.Top']))]; 
            ctx._source.Right = [(params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Right'] == null ? '' : Integer.toString(params['after.Right']))]; 
            ctx._source.Bottom = [(params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Bottom'] == null ? '' : Integer.toString(params['after.Bottom']))]; 
            ctx._source.Left = [(params['after.Order'] == null ? '' : Integer.toString(params['after.Order'])) + '.' + (params['after.Left'] == null ? '' : Integer.toString(params['after.Left']))]; 
            ctx._source.OrderImg360 = [params['after.Order']]; 
        } 
    } 
}