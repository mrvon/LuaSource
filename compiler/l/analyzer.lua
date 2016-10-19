local Scanner = require "scanner"
local Parser = require "parser"
local SymbolTable = require "symbol_table"

local TokenType     = Scanner.TokenType
local NodeKind      = Parser.NodeKind
local StatementKind = Parser.StatementKind
local ExpKind       = Parser.ExpKind
local ExpType       = Parser.ExpType

local g_st = SymbolTable.new()

-- counter for variable memory locations
local g_location = 0

local function type_error(tree, message)
    assert(message)
    print(string.format("type error at line %d: %s\n", tree.lineno, message))
    print(debug.traceback())
end

local function traverse(tree, pre_proc, post_proc)
    if tree then
        if pre_proc then
            pre_proc(tree)
        end

        for i = 1, #tree.child do
            traverse(tree.child[i], pre_proc, post_proc)
        end

        if post_proc then
            post_proc(tree)
        end

        traverse(tree.sibling, pre_proc, post_proc)
    end
end

local function insert_node(tree)
    if tree.node_kind == NodeKind.STATEMENT then
        if tree.kind == StatementKind.ASSIGN or
            tree.kind == StatementKind.READ then
            local location = g_st:lookup(tree.attr_str) 
            if location == nil then
                g_st:insert(tree.attr_str, tree.lineno, g_location)
                g_location = g_location + 1
            else
                g_st:insert(tree.attr_str, tree.lineno)
            end
        else
            -- do nothing
        end
    elseif tree.node_kind == NodeKind.EXP then
        if tree.kind == ExpKind.ID then
            local location = g_st:lookup(tree.attr_str) 
            if location == nil then
                g_st:insert(tree.attr_str, tree.lineno, g_location)
                g_location = g_location + 1
            else
                g_st:insert(tree.attr_str, tree.lineno)
            end
        else
            -- do nothing
        end
    else
        -- do nothing
    end
end

local function build_symbol_table(tree)
    traverse(tree, insert_node, nil)
    g_st:print()
end

local function check_node(tree)
    if tree.node_kind == NodeKind.STATEMENT then
        if tree.kind == StatementKind.IF then
            if tree.child[1].type ~= ExpType.BOOLEAN then
                type_error(tree.child[1], "if test is not Boolean")
            end
        elseif tree.kind == StatementKind.ASSIGN then
            if tree.child[1].type ~= ExpType.INTEGER then
                type_error(tree.child[1], "assignment of non-integer value")
            end
        elseif tree.kind == StatementKind.WRITE then
            if tree.child[1].type ~= ExpType.INTEGER then
                type_error(tree.child[1], "write of non-integer value")
            end
        elseif tree.kind == StatementKind.REPEAT then
            if tree.child[2].type ~= ExpType.BOOLEAN then
                type_error(tree.child[2], "repeat test is not Boolean")
            end
        else
            -- do nothing
        end
    elseif tree.node_kind == NodeKind.EXP then
        if tree.kind == ExpKind.OP then
            if tree.child[1].type ~= ExpType.INTEGER or
                tree.child[2].type ~= ExpType.INTEGER then
                type_error(t, "Op applied to non-integer")
            end
            if tree.attr_id == TokenType.LT or tree.attr_id == TokenType.EQ then
                tree.type = ExpType.BOOLEAN
            else
                tree.type = ExpType.INTEGER
            end
        elseif tree.kind == ExpKind.CONST or
            tree.kind == ExpKind.ID then
            tree.type = ExpType.INTEGER
        else
            -- do nothing
        end
    end
end

local function type_check(tree)
    traverse(tree, nil, check_node)
end

local function analyze()
    local tree = Parser.parse()
    Parser.trace(tree)

    build_symbol_table(tree)
    type_check(tree)
end

return {
    analyze = analyze
}
