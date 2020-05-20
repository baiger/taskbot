exports.isForTaskBot = function (msg, client) {
    return (msg.channel.name === "tease-a-bot" || msg.mentions.has(client.user))
	&& msg.content.toLowerCase().startsWith(process.env.COMMAND_PREFIX)
	&& msg.author.id != process.env.BOT_ID; // no bouncing
}
