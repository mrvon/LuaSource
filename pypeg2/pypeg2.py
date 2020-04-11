import pypeg2 as peg


class Type(peg.Keyword):
    grammar = (peg.Enum(peg.K("int"), peg.K("long")))


class Parameter:
    grammar = (peg.attr("typing", Type), peg.blank, peg.name())


class Parameters(peg.Namespace):
    grammar = peg.optional(peg.csl(Parameter))


class Instruction(str):
    def heading(self, parser):
        return ("/* on level " + str(parser.indention_level) + " */", peg.endl)

    grammar = (heading, peg.word, ";", peg.endl)


Block = ("{", peg.endl, peg.maybe_some(peg.indent(Instruction)), "}", peg.endl)


class Function(peg.List):
    grammar = (peg.attr("typing", Type), peg.blank, peg.name(), "(",
               peg.attr("parms", Parameters), ")", peg.endl, Block)


source = '''
int f(int a, long b) {
    do_this;
    do_that;
}'''

f = peg.parse(source, Function)
print(f.typing)
print(f.name)
print(f.parms['a'].typing)
print(f.parms['b'].typing)
print(peg.compose(f, autoblank=False))
