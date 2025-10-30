vim.diagnostic.config({
  signs = false,
})

vim.filetype.add({
  extension = {
    postcss = 'css',
  },
})

local original_text_document_definition = vim.lsp.handlers['textDocument/definition']

local function location_key(res)
  local uri = res.targetUri or res.uri
  if not uri then
    return nil
  end

  local range = res.targetRange or res.range
  if range and range.start and range['end'] then
    return string.format(
      '%s:%d:%d:%d:%d',
      uri,
      range.start.line,
      range.start.character,
      range['end'].line,
      range['end'].character
    )
  end

  return uri
end

local function dedupe_definition_results(result)
  if type(result) ~= 'table' or not vim.tbl_islist(result) or #result <= 1 then
    return result
  end

  local seen = {}
  local unique_results = {}

  for _, res in ipairs(result) do
    local key = location_key(res)
    if not key or not seen[key] then
      unique_results[#unique_results + 1] = res
      if key then
        seen[key] = true
      end
    end
  end

  return unique_results
end

vim.lsp.handlers['textDocument/definition'] = function(err, result, ...)
  return original_text_document_definition(err, dedupe_definition_results(result), ...)
end
