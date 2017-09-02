server_path=~/leveldb/
for f in $(find $server_path \
    -name '*.cpp'            \
    -or -name '*.cc'         \
    -or -name '*.h'          \
    -or -name '*.hpp')
do
    clang-format -style="{                                      \
        BasedOnStyle : WebKit,                                  \
        AccessModifierOffset : -4,                              \
        AlignAfterOpenBracket : AlwaysBreak,                    \
        AlignConsecutiveAssignments : false,                    \
        AlignConsecutiveDeclarations : false,                   \
        AlignOperands : false,                                  \
        AlignTrailingComments : true,                           \
        AllowAllParametersOfDeclarationOnNextLine : false,      \
        AllowShortBlocksOnASingleLine : false,                  \
        AllowShortCaseLabelsOnASingleLine : false,              \
        AllowShortFunctionsOnASingleLine : None,                \
        AllowShortIfStatementsOnASingleLine : false,            \
        AllowShortLoopsOnASingleLine : false,                   \
        AlwaysBreakAfterDefinitionReturnType : false,           \
        AlwaysBreakAfterReturnType : None,                      \
        AlwaysBreakBeforeMultilineStrings : true,               \
        AlwaysBreakTemplateDeclarations : true,                 \
        BinPackArguments : false,                               \
        BinPackParameters : false,                              \
        BreakBeforeBraces : Custom,                             \
        BraceWrapping : {                                       \
            AfterClass : false,                                 \
            AfterControlStatement : false,                      \
            AfterEnum : false,                                  \
            AfterNamespace : false,                             \
            AfterObjCDeclaration : false,                       \
            AfterStruct : false,                                \
            AfterUnion : false,                                 \
            BeforeCatch : false,                                \
            BeforeElse : false,                                 \
            IndentBraces : false,                               \
            AfterFunction : false,                              \
        },                                                      \
        IndentWidth : 4,                                        \
        ColumnLimit : 80,                                       \
    }"                                                          \
    -i $f
done
