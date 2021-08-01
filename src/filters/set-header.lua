local title

return {{
    Meta = function(meta)
        title = meta.title
    end
}, {
    Header = function(header)
        if header.level == 1 and not title then
            title = header.content
        end
        return header
    end
}, {
    Meta = function(meta)
        meta.title = title;
        return meta
    end
}}
