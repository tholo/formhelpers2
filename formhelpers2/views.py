import colander
from pyramid.renderers import render_to_response
from pyramid.view import view_config

from formhelpers2.mako import Form

HEARD_CHOICES = [
    ('internet', 'the internet'),
    ('friend', 'from a friend'),
    ('radio', 'on the radio (really?)'),
]


class CommentForm(colander.MappingSchema):
    name = colander.SchemaNode(
        colander.String(),
        default='')

    heard = colander.SchemaNode(
        colander.String(),
        validator=colander.OneOf([c[0] for c in HEARD_CHOICES]),
        default='internet')

    comment = colander.SchemaNode(
        colander.String(),
        default='')


@view_config(renderer='comment.mako')
def comment(request):
    form = Form(CommentForm(), 'comment_form')
    if 'comment' in request.POST:
        try:
            appstruct = form.validate(request.POST)
            return render_to_response('thanks.mako',
                                      dict(name=appstruct['name']),
                                      request=request)
        except colander.Invalid, e:
            return dict(forms=form.render(request.POST, e.asdict()),
                        heard_choices=HEARD_CHOICES)
    return dict(forms=form.render(),
                heard_choices=HEARD_CHOICES)
