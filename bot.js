require('dotenv').config();

const D = require('discord.js');
const client = new D.Client();

client.login(process.env.BOT_TOKEN);

client.on('ready', () => {
    console.log(`Logged in as ${client.user.tag}!`);
});

client.on('message', msg => {
  if (msg.content === 'test bot') {
    msg.reply('Hello World!');
  }
});
