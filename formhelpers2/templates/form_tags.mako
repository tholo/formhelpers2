<%doc>
    
    Mako form tag library.
    
</%doc>

<%def name="errors(name)">\
<%doc>
    Given a field name, produce a stylized error message from the current
    form_errors collection, if one is present.  Else render nothing.
</%doc>\
% if hasattr(forms, 'errors') and name in forms.errors:
<div class="error-message">${forms.errors[name]}</div>\
% endif
</%def>

<%def name="form(name, url=None, multipart=False, **attrs)">
<%doc>
    Render an HTML <form> tag - the body contents will be rendered within.
    
        name - the name of a dictionary placed on 'forms' which contains form values.
        url - URL to be POSTed to
</%doc><%
    form = getattr(forms, name)
    if not isinstance(form, dict):
        raise Exception("No form dictionary found at forms.%s" % name)
    forms._form = form
    if not url:
        url = request.url
%>\
${h.form(url, name=name, multipart=coerce_bool(multipart), **attrs)}\
${caller.body()}\
${h.end_form()}\
<%
    del forms._form
%></%def>

<%def name="text(name, **attrs)" decorator="render_error">\
<%doc>
    Render an HTML <input type="text"> tag.
</%doc>\
${h.text(name, value=form_value(forms, name), **attrs)}
</%def>

<%def name="upload(name, **attrs)" decorator="render_error">\
<%doc>
    Render an HTML <file> tag.
</%doc>\
${h.file(name, **attrs)}
</%def>

<%def name="hidden(name, **attrs)">\
<%doc>
    Render an HTML <input type="hidden"> tag.
</%doc>\
${h.hidden(name, value=form_value(forms, name), **attrs)}\
</%def>

<%def name="password(name, **attrs)" decorator="render_error">\
<%doc>
    Render an HTML <input type="password"> tag.
</%doc>\
${h.password(name, value=form_value(forms, name), **attrs)}
</%def>

<%def name="textarea(name, **attrs)" decorator="render_error">\
<%doc>
    Render an HTML <textarea></textarea> tag pair with embedded content.
</%doc>\
${h.textarea(name, content=form_value(forms, name), **attrs)}
</%def>

<%def name="select(name, options=None, **kw)" decorator="render_error">\
<%doc>
    Render an HTML <select> tag.  Options within the tag
    are generated using the "option" %def.   Additional
    items can be passed through the "options" argument -
    these are rendered after the literal <%options> tags.
</%doc>\
<%
    forms._select_options = tuples = []
    if options is None:
        options = []

    capture(caller.body)

    selected = form_value(forms, name)
    if not selected:
        i = 0
        selected = []
        while True:
            v = form_value(forms, name + "-%d" % i)
            if v:
                selected.append(v)
                i += 1
            else:
                break
%>\
${h.select(name, selected, [(t[0], t[1]) for t in tuples] + options, **kw)}\
<%
    del forms._select_options
%></%def>

<%def name="option(value)">\
<%doc>
    Render an HTML <option> tag.  This is meant to be used with 
    the "select" %def and produces a special return value specific to
    usage with that function.
</%doc>\
<%
    forms._select_options.append((value, capture(caller.body).strip()))
%></%def>

<%def name="checkbox(name, value='true')" decorator="render_error">\
<%doc>
    Render an HTML <checkbox> tag.  The value is rendered as 'true'
    by default for usage with the StringBool validator.
</%doc>
${h.checkbox(name, value, checked=form_value(forms, name) == value)}\
${errors(name)}
</%def>

<%def name="radio(name, value)" decorator="render_error">\
<%doc>
    Render an HTML <radio> tag.
</%doc>
${h.radio(name, value, checked=form_value(forms, name) == value)}\
${errors(name)}
</%def>

<%def name="submit(value=None, name=None, **kwargs)">\
<%doc>
    Render an HTML <submit> tag.
</%doc>\
${h.submit(name=name, value=value, **kwargs)}\
</%def>

<%!
    def render_error(fn):
        """Decorate a form field to render an error message or asterisk."""

        def decorate(context, name, *args, **kw):
            error_message = get_error_message(context, name)

            fn(name, *args, **kw)

            if error_message:
                context.write('<span id="%s_error" class="error-message">%s</span>' % (name, error_message))
            return ''

        return decorate

    def get_error_message(context, name):
        forms = context['forms']

        if hasattr(forms, 'errors') and \
            name in forms.errors:
            error_message = forms.errors[name]
        else:
            error_message = None

        return error_message

    def coerce_bool(arg):
        if isinstance(arg, basestring):
            return eval(arg)
        elif isinstance(arg, bool):
            return arg
        else:
            raise ArgumentError("%r could not be coerced to boolean" % arg)
    
    def form_value(forms, name):
        try:
            return forms._form.get(name)
        except AttributeError:
            raise Exception("Form tag used without a form "
                "context present; ensure that forms.{form name} is "
                "populated with a dict, and that this tag is enclosed "
                "within the %form() tag from this library.")
%>
