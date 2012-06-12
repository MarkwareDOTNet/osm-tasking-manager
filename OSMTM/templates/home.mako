<%!
    import markdown
    from OSMTM.utils import timesince
%>
<%inherit file="/base.mako"/>
<%def name="id()">home</%def>
<%def name="title()">HOT Task Server - Home Page</%def>
<div class="container">
    <div class="row"> 
    <div class="span7">
        <div class="pull-right">
            % if current_tag is not None:
            <div class="inline">${current_tag}&nbsp;<a class="close" title="Show all jobs" href="?">&times;</a></div>
            % endif
            <div class="dropdown inline">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">Tags
                    <b class="caret"></b>
                </a>
                <ul class="dropdown-menu">
                    % for tag in tags:
                    <li><a href="?tag=${tag.tag}">${tag.tag}</a></li>
                    % endfor
                </ul>
            </div>
        </div>
    </div>
    <div class="span7">
    % if jobs:
        % for job in jobs:
            % if user.is_admin() or job.status == 1:
                <%
                    archived = 'archived' if job.status == 0 else ''
                %>
                <div class="job ${archived} well">
                <%
                    users = job.get_current_users()
                %>
                <ul class="nav job-stats">
                    % if len(users) > 0:
                    <li title="Currently working: ${", ".join(users)|n}">
                        <i class="icon-user"></i>${len(users)}
                    </li>
                    % endif
                    <li class="row">
                        <table>
                            <tr>
                                <td>
                                    <div class="progress" style="border: 1px solid #ccc"><div class="bar" style="width:${job.get_percent_done()}%"></div></div>
                                </td>
                                <td>
                                    ${job.get_percent_done()}%
                                </td>
                            </tr>
                        </table>
                    </li>
                </ul>
                <h4>
                    <a href="${request.route_url('job', job=job.id)}">${job.title}</a>
                    % if job.is_private:
                    <img src="${request.static_url('OSMTM:static/img/lock.gif')}" alt="private" title="private job" />
                    % endif
                    % for tag in job.tags:
                    <a href="?tag=${tag.tag}"><span class="tag label">${tag.tag}</span></a>
                    % endfor
                </h4>
                <%
                    description = job.short_description if job.short_description != '' else job.description
                %>
                <p>${markdown.markdown(description)|n}</p>
                % if user.is_admin():
                <p class="admin-links">
                    % if job.status == 1:
                        <a href="${request.route_url('job_archive', job=job.id)}" class="archive" alt="archive" title="Archive the job">archive</a>
                    % elif job.status == 0:
                        <a href="${request.route_url('job_publish', job=job.id)}" class="publish" alt="publish" title="Publish the job">publish</a>
                    % endif
                    |
                    <a href="${request.route_url('job_edit', job=job.id)}" class="edit" alt="edit" title="Edit the job">edit</a>
                    |
                    <a href="${request.route_url('job_delete', job=job.id)}" class="delete" alt="delete" title="Delete the job">delete</a>
                </p>
                % endif
                <%
                    last_update = job.get_last_update()
                %>
                % if last_update is not None:
                <p class="updated-at">Last updated ${timesince(last_update)} ago</p>
                % endif
                </div>
            % endif
        % endfor
    % endif
    </div>
    <div class="span5">
        % if admin:
        <div class="form-actions">
            <a href="${request.route_url('job_new')}" class="btn">+ Create a new job</a>
        </div>
        % endif
    </div>
    </div>
</div>
<script type="text/javascript" src="${request.static_url('OSMTM:static/js/home.js')}"></script>
