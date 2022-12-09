local mod = {}

-- Anycomplete
function mod.anycomplete()
    local GOOGLE_ENDPOINT = 'https://suggestqueries.google.com/complete/search?client=firefox&q=%s'
    local current = hs.application.frontmostApplication()
    local tab = nil
    local copy = nil
    local choices = {}

    function current_selection()
        local elem=hs.uielement.focusedElement()
        local sel=nil
        if elem then
            sel=elem:selectedText()
        end
        if (not sel) or (sel == "") then
            hs.eventtap.keyStroke({"cmd"}, "c")
            hs.timer.usleep(20000)
            sel=hs.pasteboard.getContents()
        else
            print("sel:" .. sel)   
        end
        return (sel or "")
    end

    -- local start_string = current_selection()

    local chooser = hs.chooser.new(function(choosen)
        if copy then copy:delete() end
        if tab then tab:delete() end
        current:activate()
        if not choosen == nil then
            hs.eventtap.keyStrokes(choosen.text)
        end
    end)

    -- Removes all items in list
    function reset()
        chooser:choices({})
    end

    tab = hs.hotkey.bind('', 'tab', function()
        local id = chooser:selectedRow()
        local item = choices[id]
        -- If no row is selected, but tab was pressed
        if not item then return end
        chooser:query(item.text)
        reset()
        updateChooser()
    end)

    copy = hs.hotkey.bind('cmd', 'c', function()
        local id = chooser:selectedRow()
        local item = choices[id]
        if item then
            chooser:hide()
            hs.pasteboard.setContents(item.text)
            hs.alert.show("Copied to clipboard", 1)
        else
            hs.alert.show("No search result to copy", 1)
        end
    end)
    
    function updateChooser()
        local string = chooser:query()
        local query = hs.http.encodeForQuery(string)
        -- Reset list when no query is given
        if string:len() == 0 then return reset() end

        hs.http.asyncGet(string.format(GOOGLE_ENDPOINT, query), nil, function(status, data)
            if not data then return end

            local ok, results = pcall(function() return hs.json.decode(data) end)
            if not ok then return end

            choices = hs.fnutils.imap(results[2], function(result)
                return {
                    ["text"] = result,
                }
            end)

            chooser:choices(choices)
        end)
    end

    function loadSelected()
        if not (start_string == nil) then
            chooser:query(start_string)
            reset()
            updateChooser()
        end
    end

    chooser:queryChangedCallback(updateChooser)

    chooser:searchSubText(false)

    -- loadSelected()

    chooser:show()

end

function mod.registerDefaultBindings(mods, key)
    mods = mods or {"cmd", "alt", "ctrl"}
    key = key or "G"
    hs.hotkey.bind(mods, key, mod.anycomplete)
end

function mod:bind(mods, key)
    mod.registerDefaultBindings(mods, key)
end

return mod
