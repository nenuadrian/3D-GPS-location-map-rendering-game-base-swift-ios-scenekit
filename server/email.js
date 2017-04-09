
var winston = require('winston'),
  config = require('./config'),
  helper = require('sendgrid').mail,
  sg = require('sendgrid')(config.SENDGRID_API_KEY),
  from_email = new helper.Email('contact@test.nenuadrian.com');

function send(to, subject, content) {
  var to_email = new helper.Email(to)
  var content = new helper.Content('text/html', content)
  var mail = new helper.Mail(from_email, subject, to_email, content)
  var request = sg.emptyRequest({
    method: 'POST',
    path: '/v3/mail/send',
    body: mail.toJSON(),
  })
  sg.API(request)
    .then(response => {
    })
    .catch(err => winston.error('Sending email w/ err: ' + err.response.statusCode))
}

var templates = {
  'welcome' : {
    'subject' : 'Welcome',
    'content' : 'Let the hacking begin'
  }
}
module.exports = {
  sendByTemplate: function(to, template, tVars = false) {
    var template = JSON.parse(JSON.stringify(templates[template]))
    if (template) {
      Object.keys(tVars).forEach(k => template.content = template.content.replace(k, tVars[k]))
      return send(to, template.subject, template.content)
    } else {
      winston.error('Template not found: ' + template + ' in an attempt to send to ' + to);
    }
    return null
  }
}
