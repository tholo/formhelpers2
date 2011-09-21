from pyramid.events import BeforeRender
from pyramid.events import NewRequest
from pyramid.events import subscriber
from pyramid.httpexceptions import HTTPForbidden

from webhelpers.html import tags


@subscriber(BeforeRender)
def add_renderer_globals(event):
    event['h'] = tags


@subscriber(NewRequest)
def csrf_validation(event):
    request = event.request
    if request.method == 'POST':
        token = request.POST.get('_csrf')
        if token is None or token != request.session.get_csrf_token():
            raise HTTPForbidden('Cross Site Request Forgery detected')
