<%namespace name="form" file="/form_tags.mako"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>Mako Form Helpers</title>
  <link rel="stylesheet" href="${request.static_url('formhelpers2:static/style.css')}" type="text/css" />
</head>
<body>

<h3>Using Mako Helpers</h3>

<%form:form name="comment_form" controller="comment" action="post">
<div style="display: none;">
    <input type="hidden" name="_csrf" value="${request.session.get_csrf_token()}" />
</div>
<table>
    <tr>
        <th colspan="2">Submit your Comment</th>
    </tr>
    <tr>
        <td>Your Name:</td>
        <td><%form:text name="name"/></td>
    </tr>

    <tr>
        <td>How did you hear about this site ?</td>
        <td>
            <%form:select name="heard" options="${heard_choices}">
                <%form:option value="">None</%form:option>
            </%form:select>
        </td>
    </tr>

    <tr>
        <td>Comment:</td>
        <td><%form:textarea name="comment"/></td>
    </tr>

    <tr>
        <td colspan="2"><%form:submit/></td>
    </tr>
</table>
</%form:form>

</body>
</html>
