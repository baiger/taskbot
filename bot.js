// Node.js modules
require('dotenv').config();
const Discord = require('discord.js');

// local modules
const Util = require('./modules/util.js');
const Command = require('./modules/command.js');
const Logger = require('./modules/log.js');
const DB = require('./modules/database.js');

const client = new Discord.Client();
client.login(process.env.BOT_TOKEN);

client.on('ready', () => {
    Logger.log(`Logged in as ${client.user.tag}!`);
});

client.on('message', msg => {
    if (Util.isForTaskBot(msg, client)) {
	var res = Command.parseCommand(msg.content.slice(process.env.COMMAND_PREFIX.length));
	// console.log(res);
	msg.reply(res);
    }
});

