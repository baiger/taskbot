// Node.js module
const Yargs = require('yargs');
var res;
var handled;

function handleOutput(err, argv, output) {
    if (!handled) {
	res = output;
    }
}

function manageTask(argv) {
    res = [argv.action, argv.names];
    handled = true;
}

function managePermission(argv) {
    res = argv.action;
    handled = true;
}


exports.parseCommand = function (msg) {
    var parser = Yargs()
	  .scriptName(process.env.COMMAND_PREFIX)
	  .command('task <action> [names|numbers..]', 'manage tasks',
		   {			// builder
		       action: {
			   demand: true,
			   choices: ['add', 'edit', 'delete']
		       },
		       names: {
			   demand: true
		       }
		   },
		   manageTask)
	  .command('admin <action>', 'manage task permissions on this server',
		   {			// builder
		   },
		   managePermission)
	  .fail(function (msg, err, yargs) {
    	      throw [err, msg];
	  })
	.help();
    
    try {
	handled = false;
	parser.parse(msg, handleOutput);
	return res;
    }
    catch (err) {
	return err;
    }
}
