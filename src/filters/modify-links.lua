function modify_link(link)
    link.attributes["rel"] = "noopener"

    if link.target:find("^http") ~= nil then
      link.attributes["target"] = "_blank"
    end

    return link
end

return {{
    Link = modify_link
}}
