import re


class Form(object):
    class FormContext(object):
        pass

    def __init__(self, schema, name):
        self.schema = schema
        self.name = name

    def validate(self, data):
        return self.schema.deserialize(data)

    def render(self, data=None, errors=None, context=None, **kw):
        if not context:
            context = self.FormContext()
        if not data:
            data = self.schema.serialize()

        setattr(context, self.name, dict(data.iteritems()))

        if errors:
            if hasattr(context, 'errors'):
                context.errors.update(errors)
            else:
                context.errors = errors

        for key, val in kw.items():
            setattr(context, key, val)

        return context


tag_regexp = re.compile(r'<(\/)?%(\w+):(\w+)\s*(.*?)(\/)?>', re.S)
attr_regexp = re.compile(
    r"\s*(\w+)\s*=\s*(?:(?<!\\)'(.*?)(?<!\\)'|(?<!\\)\"(.*?)(?<!\\)\")")
expr_regexp = re.compile(r'\${(.+?)}')


def process_tags(source):
    """Convert tags of the form <nsname:funcname attrs> into a <%call> tag.

    This is a quick regexp approach that can be replaced with a full blown
    XML parsing approach, if desired.

    """
    def process_exprs(t):
        m = re.match(r'^\${(.+?)}$', t)
        if m:
            return m.group(1)

        att = []

        def replace_expr(m):
            att.append(m.group(1))
            return "%s"

        t = expr_regexp.sub(replace_expr, t)
        if att:
            return "'%s' %% (%s)" % (t.replace("'", r"\'"), ",".join(att))
        else:
            return "'%s'" % t.replace("'", r"\'")

    def cvt(match):
        if bool(match.group(1)):
            return "</%call>"

        ns = match.group(2)
        fname = match.group(3)
        attrs = match.group(4)

        attrs = dict([(key, process_exprs(val1 or val2))
                      for key, val1, val2 in attr_regexp.findall(attrs)])
        args = attrs.pop("args", "")

        attrs = ",".join(["%s=%s" % (key, value)
                          for key, value in attrs.iteritems()])

        if bool(match.group(5)):
            return """<%%call expr="%s.%s(%s)" args=%s/>""" % (
                ns, fname, attrs, args)
        else:
            return """<%%call expr="%s.%s(%s)" args=%s>""" % (
                ns, fname, attrs, args)
    return tag_regexp.sub(cvt, source)
