local list_extend = vim.list_extend

--- @param line string
--- @param max_width number
--- @return table
local format_line = function(line, max_width)
	if line == "" then
		return { " " }
	end

	local formatted_line = {}

	-- split line by spaces into list of words
	local words = {}
	local target = "%S+"
	for word in line:gmatch(target) do
		table.insert(words, word)
	end

	local bufstart = " "
	local buffer = bufstart
	for i, word in ipairs(words) do
		if (#buffer + #word) <= max_width then
			buffer = buffer .. word .. " "
			if i == #words then
				table.insert(formatted_line, buffer:sub(1, -2))
			end
		else
			table.insert(formatted_line, buffer:sub(1, -2))
			buffer = bufstart .. word .. " "
			if i == #words then
				table.insert(formatted_line, buffer:sub(1, -2))
			end
		end
	end
	-- right-justify text if the line begins with -
	if line:sub(1, 1) == "-" then
		for i, val in ipairs(formatted_line) do
			local space = string.rep(" ", max_width - #val - 2)
			formatted_line[i] = space .. val:sub(2, -1)
		end
	end
	return formatted_line
end

--- @param quote table
--- @param max_width number
--- @return table
local format_quote = function(quote, max_width)
	-- Converts list of strings to one formatted string (with linebreaks)
	local formatted_quote = { " " } -- adds spacing between alpha-menu and footer
	for _, line in ipairs(quote) do
		local formatted_line = format_line(line, max_width)
		formatted_quote = list_extend(formatted_quote, formatted_line)
	end
	return formatted_quote
end

local get_quote = function(quote_list)
	-- selects an entry from quotes_list randomly
	math.randomseed(os.time())
	local ind = math.random(1, #quote_list)
	return quote_list[ind]
end

local quote_list = {
	{ "Code is the poetry of logic, and through its simplicity, I find elegance, purpose, and the art of creation." },
	{ "Simplicity is the ultimate sophistication.", "", "- Steve Jobs" },
	{ "Waste no more time arguing what a good man should be. Be one.", "", "- Marcus Aurelius" },
	{ "The impediment to action advances action. What stands in the way becomes the way.", "", "- Marcus Aurelius" },
	{ "Dwell on the beauty of life. Watch the stars, and see yourself running with them.", "", "- Marcus Aurelius" },
	{ "The only way to do great work is to love what you do.", "", "- Steve Jobs" },
	{
		"Your work is going to fill a large part of your life, and the only way to be truly satisfied is to do what you believe is great work.",
		"",
		"- Steve Jobs",
	},
	{ "Truth can only be found in one place: the code.", "", "- Uncle Bob" },
	{ "Clean code always looks like it was written by someone who cares.", "", "- Uncle Bob" },
	{ "The only way to go fast, is to go well.", "", "- Uncle Bob" },
	{
		"In the depth of winter, I finally learned that within me there lay an invincible summer.",
		"",
		"- Albert Camus",
	},
	{ "But in the end one needs more courage to live than to kill himself.", "", "- Albert Camus" },
	{ "A man without ethics is a wild beast loosed upon this world.", "", "- Albert Camus" },
	{ "Do or do not. There is no try.", "", "- Yoda" },
	{ "Your focus determines your reality.", "", "- Qui-Gon Jinn" },
	{ "In my experience, there is no such thing as luck.", "", "- Obi-Wan Kenobi" },
	{ "I can do all things through Christ who strengthens me.", "", "- Philippians 4:13" },
	{
		"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
		"",
		"- Jeremiah 29:11",
	},
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "The end of something is always the beginning of something else.", "", "- Better Call Saul" },
	{ "You don’t need to be a lawyer to understand what’s right and wrong.", "", "- Better Call Saul" },
	{ "In this world, you gotta make your own luck.", "", "- Better Call Saul" },
	{
		"The night is darkest just before the dawn. And I promise you, the dawn is coming.",
		"",
		"- Harvey Dent, The Dark Knight",
	},
	{ "We are what we repeatedly do. Excellence, then, is not an act, but a habit.", "", "- Aristotle" },
	{ "To live is the rarest thing in the world. Most people exist, that is all.", "", "- Oscar Wilde" },
	{ "Not all those who wander are lost.", "", "- J.R.R. Tolkien" },
	{ "The only thing necessary for the triumph of evil is for good men to do nothing.", "", "- Edmund Burke" },
	{ "May the Force be with you.", "", "- Star Wars" },
	{ "In the end, it's not the years in your life that count. It's the life in your years.", "", "- Abraham Lincoln" },
	{ "The unexamined life is not worth living.", "", "- Socrates" },
	{ "The Lord is my shepherd; I shall not want.", "", "- Psalm 23:1" },
	{ "All that is gold does not glitter, not all those who wander are lost.", "", "- J.R.R. Tolkien" },
	{ "For where your treasure is, there your heart will be also.", "", "- Matthew 6:21" },
	{ "Judge not, that you be not judged.", "", "- Matthew 7:1" },
	{
		"The greatest glory in living lies not in never falling, but in rising every time we fall.",
		"",
		"- Nelson Mandela",
	},
	{ "It’s not who I am underneath, but what I do that defines me.", "", "- Batman, Batman Begins" },
	{
		"Sometimes it is the people no one imagines anything of who do the things that no one can imagine.",
		"",
		"- Alan Turing",
	},
	{ "I'm no one to anyone, and that gives me freedom.", "", "- Better Call Saul" },
	{
		"To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.",
		"",
		"- Ralph Waldo Emerson",
	},
	{ "All we have to decide is what to do with the time that is given to us.", "", "- J.R.R. Tolkien" },
	{
		"Life's most persistent and urgent question is, 'What are you doing for others?'",
		"",
		"- Martin Luther King Jr.",
	},
	{
		"Not everything that is faced can be changed, but nothing can be changed until it is faced.",
		"",
		"- James Baldwin",
	},
	{ "Our greatest glory is not in never failing, but in rising every time we fall.", "", "- Confucius" },
	{ "Blessed are the peacemakers, for they shall be called sons of God.", "", "- Matthew 5:9" },
	{ "I am the way, and the truth, and the life. No one comes to the Father except through me.", "", "- John 14:6" },
	{ "If you want to make enemies, try to change something.", "", "- Woodrow Wilson" },
	{
		"Imagination is more important than knowledge. Knowledge is limited. Imagination encircles the world.",
		"",
		"- Albert Einstein",
	},
	{ "A journey of a thousand miles begins with a single step.", "", "- Lao Tzu" },
	{ "Faith is taking the first step even when you don't see the whole staircase.", "", "- Martin Luther King Jr." },
	{ "The time is always right to do what is right.", "", "- Martin Luther King Jr." },
	{ "God has given us two hands, one to receive with and the other to give with.", "", "- Billy Graham" },
	{ "Let the one who boasts, boast in the Lord.", "", "- 1 Corinthians 1:31" },
	{
		"I am the resurrection and the life. Whoever believes in me, though he die, yet shall he live.",
		"",
		"- John 11:25",
	},
	{ "Do not let your hearts be troubled. Trust in God; trust also in me.", "", "- John 14:1" },
	{ "There is no greater love than to lay down one’s life for one’s friends.", "", "- John 15:13" },
	{ "As iron sharpens iron, so one person sharpens another.", "", "- Proverbs 27:17" },
	{ "Better to live one year as a lion, than a hundred as a sheep.", "", "- Benito Mussolini" },
	{
		"Fear is the path to the dark side. Fear leads to anger; anger leads to hate; hate leads to suffering.",
		"",
		"- Yoda",
	},
	{ "In my experience, there's no such thing as luck.", "", "- Obi-Wan Kenobi" },
	{ "This is the way.", "", "- The Mandalorian" },
	{ "The Force will be with you. Always.", "", "- Obi-Wan Kenobi" },
	{ "Even the smallest person can change the course of the future.", "", "- J.R.R. Tolkien" },
	{ "Be the change that you wish to see in the world.", "", "- Mahatma Gandhi" },
	{ "God doesn’t call the qualified, He qualifies the called.", "", "- Unknown" },
	{
		"Success is not final, failure is not fatal: It is the courage to continue that counts.",
		"",
		"- Winston Churchill",
	},
	{ "We walk by faith, not by sight.", "", "- 2 Corinthians 5:7" },
	{
		"Love is patient, love is kind. It does not envy, it does not boast, it is not proud.",
		"",
		"- 1 Corinthians 13:4",
	},
	{
		"And now these three remain: faith, hope and love. But the greatest of these is love.",
		"",
		"- 1 Corinthians 13:13",
	},
	{ "Trust in the Lord with all your heart and lean not on your own understanding.", "", "- Proverbs 3:5" },
	{ "The Lord is my light and my salvation—whom shall I fear?", "", "- Psalm 27:1" },
	{
		"For I am persuaded, that neither death, nor life, nor angels, nor principalities, nor powers, nor things present, nor things to come.",
		"",
		"- Romans 8:38",
	},
	{ "The greatest wealth is to live content with little.", "", "- Plato" },
	{
		"Do not go where the path may lead, go instead where there is no path and leave a trail.",
		"",
		"- Ralph Waldo Emerson",
	},
	{ "The only limit to our realization of tomorrow is our doubts of today.", "", "- Franklin D. Roosevelt" },
	{ "Your talent is God's gift to you. What you do with it is your gift back to God.", "", "- Leo Buscaglia" },
	{ "If God is for us, who can be against us?", "", "- Romans 8:31" },
	{ "Life is 10% what happens to us and 90% how we react to it.", "", "- Charles R. Swindoll" },
	{ "The more you sweat in training, the less you bleed in battle.", "", "- Navy SEALs" },
	{
		"You can never cross the ocean until you have the courage to lose sight of the shore.",
		"",
		"- Christopher Columbus",
	},
	{ "For with God nothing shall be impossible.", "", "- Luke 1:37" },
	{ "To love another person is to see the face of God.", "", "- Les Misérables" },
	{ "I am the Alpha and the Omega, the First and the Last, the Beginning and the End.", "", "- Revelation 22:13" },
	{ "Only a life lived for others is a life worthwhile.", "", "- Albert Einstein" },
	{ "We love because He first loved us.", "", "- 1 John 4:19" },
	{ "Blessed are those who hunger and thirst for righteousness, for they shall be satisfied.", "", "- Matthew 5:6" },
	{ "Where there is no vision, the people perish.", "", "- Proverbs 29:18" },
	{ "The heavens declare the glory of God; the skies proclaim the work of his hands.", "", "- Psalm 19:1" },
	{ "He is no fool who gives what he cannot keep to gain that which he cannot lose.", "", "- Jim Elliot" },
	{ "This too shall pass.", "", "- Persian Proverb" },
	{ "Patience is bitter, but its fruit is sweet.", "", "- Aristotle" },
	{ "The fear of the Lord is the beginning of wisdom.", "", "- Proverbs 9:10" },
	{ "In three words I can sum up everything I've learned about life: it goes on.", "", "- Robert Frost" },
	{ "The way to get started is to quit talking and begin doing.", "", "- Walt Disney" },
	{ "I am a servant of the living God. I will not bow down.", "", "- Daniel 3:17-18" },
	{ "The future belongs to those who believe in the beauty of their dreams.", "", "- Eleanor Roosevelt" },
	{ "Everything you’ve ever wanted is on the other side of fear.", "", "- George Addair" },
	{ "Happiness is not something ready-made. It comes from your own actions.", "", "- Dalai Lama" },
	{ "The best way to predict the future is to create it.", "", "- Peter Drucker" },
	{ "God has a plan, and his plan is perfect.", "", "- Jeremiah 29:11" },
	{ "When you reach the end of your rope, tie a knot in it and hang on.", "", "- Franklin D. Roosevelt" },
	{ "The harder the conflict, the greater the triumph.", "", "- George Washington" },
	{ "Our lives begin to end the day we become silent about things that matter.", "", "- Martin Luther King Jr." },
	{ "Believe you can and you're halfway there.", "", "- Theodore Roosevelt" },
	{ "We are what we believe we are.", "", "- C.S. Lewis" },
	{ "The Bible is a book of promises, not a book of explanations.", "", "- Warren Wiersbe" },
	{ "God gives us the ingredients for our daily bread, but he expects us to do the baking!", "", "- Chip Ingram" },
	{ "Life without God is like an unsharpened pencil – it has no point.", "", "- Billy Graham" },
	{ "The Lord is near to the brokenhearted and saves the crushed in spirit.", "", "- Psalm 34:18" },
	{ "In the beginning was the Word, and the Word was with God, and the Word was God.", "", "- John 1:1" },
	{ "I am the good shepherd. The good shepherd lays down his life for the sheep.", "", "- John 10:11" },
	{
		"Even though I walk through the valley of the shadow of death, I will fear no evil, for you are with me.",
		"",
		"- Psalm 23:4",
	},
	{ "For what does it profit a man to gain the whole world and forfeit his soul?", "", "- Mark 8:36" },
	{
		"The thief comes only to steal and kill and destroy; I have come that they may have life, and have it to the full.",
		"",
		"- John 10:10",
	},
	{ "Blessed are the pure in heart, for they shall see God.", "", "- Matthew 5:8" },
	{ "The light shines in the darkness, and the darkness has not overcome it.", "", "- John 1:5" },
	{ "What we achieve inwardly will change outer reality.", "", "- Plutarch" },
	{ "You must be the change you wish to see in the world.", "", "- Mahatma Gandhi" },
	{ "Faith is the strength by which a shattered world shall emerge into the light.", "", "- Helen Keller" },
	{
		"We must let go of the life we have planned, so as to accept the one that is waiting for us.",
		"",
		"- Joseph Campbell",
	},
	{ "Success is how high you bounce when you hit bottom.", "", "- George S. Patton" },
	{
		"What lies behind us and what lies before us are tiny matters compared to what lies within us.",
		"",
		"- Ralph Waldo Emerson",
	},
	{ "The meaning of life is to find your gift. The purpose of life is to give it away.", "", "- Pablo Picasso" },
	{ "It always seems impossible until it's done.", "", "- Nelson Mandela" },
	{ "You cannot swim for new horizons until you have courage to lose sight of the shore.", "", "- William Faulkner" },
	{
		"The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.",
		"",
		"- Helen Keller",
	},
	{
		"The only way to discover the limits of the possible is to go beyond them into the impossible.",
		"",
		"- Arthur C. Clarke",
	},
	{
		"Challenges are what make life interesting, and overcoming them is what makes life meaningful.",
		"",
		"- Joshua J. Marine",
	},
	{ "You are never too old to set another goal or to dream a new dream.", "", "- C.S. Lewis" },
	{ "God does not call the qualified, he qualifies the called.", "", "- Unknown" },
	{ "Do what you can, with what you have, where you are.", "", "- Theodore Roosevelt" },
	{ "We cannot solve our problems with the same thinking we used when we created them.", "", "- Albert Einstein" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{ "The grace of the Lord Jesus be with all. Amen.", "", "- Revelation 22:21" },
	{
		"Let your light shine before others, so that they may see your good works and give glory to your Father who is in heaven.",
		"",
		"- Matthew 5:16",
	},
	{
		"No one can serve two masters. Either you will hate the one and love the other, or you will be devoted to the one and despise the other.",
		"",
		"- Matthew 6:24",
	},
	{
		"When one door of happiness closes, another opens; but often we look so long at the closed door that we do not see the one which has been opened for us.",
		"",
		"- Helen Keller",
	},
	{ "If you don't stand for something, you will fall for anything.", "", "- Malcolm X" },
	{ "The best time to plant a tree was 20 years ago. The second best time is now.", "", "- Chinese Proverb" },
	{ "Your word is a lamp to my feet and a light to my path.", "", "- Psalm 119:105" },
	{ "God is within her, she will not fall.", "", "- Psalm 46:5" },
	{ "The Lord will fight for you; you need only to be still.", "", "- Exodus 14:14" },
	{ "The name of the Lord is a fortified tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{
		"Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
		"",
		"- Joshua 1:9",
	},
	{ "The grass withers and the flowers fall, but the word of our God endures forever.", "", "- Isaiah 40:8" },
	{ "The steadfast love of the Lord never ceases; his mercies never come to an end.", "", "- Lamentations 3:22" },
	{
		"I have set the Lord always before me. Because he is at my right hand, I shall not be shaken.",
		"",
		"- Psalm 16:8",
	},
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge.",
		"",
		"- Psalm 18:2",
	},
	{ "In all your ways acknowledge him, and he will make straight your paths.", "", "- Proverbs 3:6" },
	{ "You are the light of the world. A city set on a hill cannot be hidden.", "", "- Matthew 5:14" },
	{ "For where two or three gather in my name, there am I with them.", "", "- Matthew 18:20" },
	{
		"But seek first his kingdom and his righteousness, and all these things will be given to you as well.",
		"",
		"- Matthew 6:33",
	},
	{ "The Lord is my shepherd, I lack nothing.", "", "- Psalm 23:1" },
	{ "I will never leave you nor forsake you.", "", "- Hebrews 13:5" },
	{ "Be strong, and let your heart take courage, all you who wait for the Lord!", "", "- Psalm 31:24" },
	{ "For nothing will be impossible with God.", "", "- Luke 1:37" },
	{ "The Lord is my strength and my song; he has become my salvation.", "", "- Exodus 15:2" },
	{
		"If you declare with your mouth, 'Jesus is Lord,' and believe in your heart that God raised him from the dead, you will be saved.",
		"",
		"- Romans 10:9",
	},
	{
		"The fear of the Lord is the beginning of knowledge, but fools despise wisdom and instruction.",
		"",
		"- Proverbs 1:7",
	},
	{ "For I know that my redeemer lives, and at the last he will stand upon the earth.", "", "- Job 19:25" },
	{
		"But the Lord is faithful, and he will strengthen you and protect you from the evil one.",
		"",
		"- 2 Thessalonians 3:3",
	},
	{
		"No temptation has overtaken you that is not common to man. God is faithful, and he will not let you be tempted beyond your ability.",
		"",
		"- 1 Corinthians 10:13",
	},
	{ "This is the day that the Lord has made; let us rejoice and be glad in it.", "", "- Psalm 118:24" },
	{ "I sought the Lord, and he answered me; he delivered me from all my fears.", "", "- Psalm 34:4" },
	{ "The Lord is a refuge for the oppressed, a stronghold in times of trouble.", "", "- Psalm 9:9" },
	{ "The Lord is gracious and compassionate, slow to anger and rich in love.", "", "- Psalm 145:8" },
	{ "The light shines in the darkness, and the darkness has not overcome it.", "", "- John 1:5" },
	{ "A friend loves at all times, and a brother is born for a time of adversity.", "", "- Proverbs 17:17" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "I can do all this through him who gives me strength.", "", "- Philippians 4:13" },
	{
		"For God did not give us a spirit of timidity, but a spirit of power, of love and of self-discipline.",
		"",
		"- 2 Timothy 1:7",
	},
	{
		"So do not fear, for I am with you; do not be dismayed, for I am your God. I will strengthen you and help you; I will uphold you with my righteous right hand.",
		"",
		"- Isaiah 41:10",
	},
	{
		"The righteous cry out, and the Lord hears them; he delivers them from all their troubles.",
		"",
		"- Psalm 34:17",
	},
	{ "Blessed are those who mourn, for they will be comforted.", "", "- Matthew 5:4" },
	{
		"The Lord will keep you from all harm—he will watch over your life; the Lord will watch over your coming and going both now and forevermore.",
		"",
		"- Psalm 121:7-8",
	},
	{ "For the word of the Lord is right and true; he is faithful in all he does.", "", "- Psalm 33:4" },
	{
		"And we know that in all things God works for the good of those who love him, who have been called according to his purpose.",
		"",
		"- Romans 8:28",
	},
	{
		"Let the morning bring me word of your unfailing love, for I have put my trust in you. Show me the way I should go, for to you I entrust my life.",
		"",
		"- Psalm 143:8",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "For you are my rock and my fortress; and for your name's sake you lead me and guide me.", "", "- Psalm 31:3" },
	{
		"The fear of the Lord is the beginning of wisdom, and knowledge of the Holy One is understanding.",
		"",
		"- Proverbs 9:10",
	},
	{
		"I will lift up my eyes to the hills—where does my help come from? My help comes from the Lord, the Maker of heaven and earth.",
		"",
		"- Psalm 121:1-2",
	},
	{ "The Lord is my shepherd, I lack nothing.", "", "- Psalm 23:1" },
	{ "But you, Lord, are a shield around me, my glory, the One who lifts my head high.", "", "- Psalm 3:3" },
	{ "God is our refuge and strength, an ever-present help in trouble.", "", "- Psalm 46:1" },
	{ "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", "", "- Psalm 34:18" },
	{
		"Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
		"",
		"- Joshua 1:9",
	},
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{
		"For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
		"",
		"- John 3:16",
	},
	{ "I will never leave you nor forsake you.", "", "- Hebrews 13:5" },
	{
		"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
		"",
		"- Jeremiah 29:11",
	},
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "The Lord is my light and my salvation—whom shall I fear?", "", "- Psalm 27:1" },
	{
		"For I am convinced that neither death nor life, neither angels nor demons, neither the present nor the future, nor any powers, neither height nor depth, nor anything else in all creation, will be able to separate us from the love of God that is in Christ Jesus our Lord.",
		"",
		"- Romans 8:38-39",
	},
	{ "The Lord is my strength and my song; he has given me victory.", "", "- Exodus 15:2" },
	{ "For where two or three gather in my name, there am I with them.", "", "- Matthew 18:20" },
	{ "I am the good shepherd. The good shepherd lays down his life for the sheep.", "", "- John 10:11" },
	{
		"Even though I walk through the darkest valley, I will fear no evil, for you are with me; your rod and your staff, they comfort me.",
		"",
		"- Psalm 23:4",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{
		"The Lord is my strength and my shield; in him my heart trusts, and I am helped; my heart exults, and with my song I give thanks to him.",
		"",
		"- Psalm 28:7",
	},
	{
		"But seek first his kingdom and his righteousness, and all these things will be given to you as well.",
		"",
		"- Matthew 6:33",
	},
	{ "I will praise you, Lord, with all my heart; I will tell of all your wonderful deeds.", "", "- Psalm 9:1" },
	{ "In the beginning was the Word, and the Word was with God, and the Word was God.", "", "- John 1:1" },
	{ "The Lord is my shepherd; I have all that I need.", "", "- Psalm 23:1" },
	{
		"I have set the Lord always before me. Because he is at my right hand, I will not be shaken.",
		"",
		"- Psalm 16:8",
	},
	{
		"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness.",
		"",
		"- Lamentations 3:22-23",
	},
	{ "But you, Lord, are a shield around me, my glory, the One who lifts my head high.", "", "- Psalm 3:3" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be strong and take heart, all you who hope in the Lord.", "", "- Psalm 31:24" },
	{ "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", "", "- Psalm 34:18" },
	{
		"But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.",
		"",
		"- Isaiah 40:31",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "The Lord is my shepherd, I lack nothing.", "", "- Psalm 23:1" },
	{ "I can do all this through him who gives me strength.", "", "- Philippians 4:13" },
	{ "For where two or three gather in my name, there am I with them.", "", "- Matthew 18:20" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{
		"But the Lord is faithful, and he will strengthen you and protect you from the evil one.",
		"",
		"- 2 Thessalonians 3:3",
	},
	{
		"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
		"",
		"- Jeremiah 29:11",
	},
	{
		"Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
		"",
		"- Joshua 1:9",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{ "I will never leave you nor forsake you.", "", "- Hebrews 13:5" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{
		"For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
		"",
		"- John 3:16",
	},
	{ "The Lord is my shepherd; I have all that I need.", "", "- Psalm 23:1" },
	{
		"I have set the Lord always before me. Because he is at my right hand, I will not be shaken.",
		"",
		"- Psalm 16:8",
	},
	{
		"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness.",
		"",
		"- Lamentations 3:22-23",
	},
	{ "But you, Lord, are a shield around me, my glory, the One who lifts my head high.", "", "- Psalm 3:3" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be strong and take heart, all you who hope in the Lord.", "", "- Psalm 31:24" },
	{ "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", "", "- Psalm 34:18" },
	{
		"But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.",
		"",
		"- Isaiah 40:31",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "The Lord is my shepherd, I lack nothing.", "", "- Psalm 23:1" },
	{ "I can do all this through him who gives me strength.", "", "- Philippians 4:13" },
	{ "For where two or three gather in my name, there am I with them.", "", "- Matthew 18:20" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{
		"But the Lord is faithful, and he will strengthen you and protect you from the evil one.",
		"",
		"- 2 Thessalonians 3:3",
	},
	{
		"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
		"",
		"- Jeremiah 29:11",
	},
	{
		"Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
		"",
		"- Joshua 1:9",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{ "I will never leave you nor forsake you.", "", "- Hebrews 13:5" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{
		"For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
		"",
		"- John 3:16",
	},
	{ "The Lord is my shepherd; I have all that I need.", "", "- Psalm 23:1" },
	{
		"I have set the Lord always before me. Because he is at my right hand, I will not be shaken.",
		"",
		"- Psalm 16:8",
	},
	{
		"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness.",
		"",
		"- Lamentations 3:22-23",
	},
	{ "But you, Lord, are a shield around me, my glory, the One who lifts my head high.", "", "- Psalm 3:3" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be strong and take heart, all you who hope in the Lord.", "", "- Psalm 31:24" },
	{ "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", "", "- Psalm 34:18" },
	{
		"But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.",
		"",
		"- Isaiah 40:31",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "The Lord is my shepherd, I lack nothing.", "", "- Psalm 23:1" },
	{ "I can do all this through him who gives me strength.", "", "- Philippians 4:13" },
	{ "For where two or three gather in my name, there am I with them.", "", "- Matthew 18:20" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{
		"But the Lord is faithful, and he will strengthen you and protect you from the evil one.",
		"",
		"- 2 Thessalonians 3:3",
	},
	{
		"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
		"",
		"- Jeremiah 29:11",
	},
	{
		"Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
		"",
		"- Joshua 1:9",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{ "I will never leave you nor forsake you.", "", "- Hebrews 13:5" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{
		"For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
		"",
		"- John 3:16",
	},
	{ "The Lord is my shepherd; I have all that I need.", "", "- Psalm 23:1" },
	{
		"I have set the Lord always before me. Because he is at my right hand, I will not be shaken.",
		"",
		"- Psalm 16:8",
	},
	{
		"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness.",
		"",
		"- Lamentations 3:22-23",
	},
	{ "But you, Lord, are a shield around me, my glory, the One who lifts my head high.", "", "- Psalm 3:3" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be strong and take heart, all you who hope in the Lord.", "", "- Psalm 31:24" },
	{ "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", "", "- Psalm 34:18" },
	{
		"But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.",
		"",
		"- Isaiah 40:31",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "The Lord is my shepherd, I lack nothing.", "", "- Psalm 23:1" },
	{ "I can do all this through him who gives me strength.", "", "- Philippians 4:13" },
	{ "For where two or three gather in my name, there am I with them.", "", "- Matthew 18:20" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{
		"But the Lord is faithful, and he will strengthen you and protect you from the evil one.",
		"",
		"- 2 Thessalonians 3:3",
	},
	{
		"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
		"",
		"- Jeremiah 29:11",
	},
	{
		"Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
		"",
		"- Joshua 1:9",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{ "I will never leave you nor forsake you.", "", "- Hebrews 13:5" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{
		"For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
		"",
		"- John 3:16",
	},
	{ "The Lord is my shepherd; I have all that I need.", "", "- Psalm 23:1" },
	{
		"I have set the Lord always before me. Because he is at my right hand, I will not be shaken.",
		"",
		"- Psalm 16:8",
	},
	{
		"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness.",
		"",
		"- Lamentations 3:22-23",
	},
	{ "But you, Lord, are a shield around me, my glory, the One who lifts my head high.", "", "- Psalm 3:3" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be strong and take heart, all you who hope in the Lord.", "", "- Psalm 31:24" },
	{ "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", "", "- Psalm 34:18" },
	{
		"But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.",
		"",
		"- Isaiah 40:31",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "The Lord is my shepherd, I lack nothing.", "", "- Psalm 23:1" },
	{ "I can do all this through him who gives me strength.", "", "- Philippians 4:13" },
	{ "For where two or three gather in my name, there am I with them.", "", "- Matthew 18:20" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{
		"But the Lord is faithful, and he will strengthen you and protect you from the evil one.",
		"",
		"- 2 Thessalonians 3:3",
	},
	{
		"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
		"",
		"- Jeremiah 29:11",
	},
	{
		"Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
		"",
		"- Joshua 1:9",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{ "I will never leave you nor forsake you.", "", "- Hebrews 13:5" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{
		"For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
		"",
		"- John 3:16",
	},
	{ "The Lord is my shepherd; I have all that I need.", "", "- Psalm 23:1" },
	{
		"I have set the Lord always before me. Because he is at my right hand, I will not be shaken.",
		"",
		"- Psalm 16:8",
	},
	{
		"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness.",
		"",
		"- Lamentations 3:22-23",
	},
	{ "But you, Lord, are a shield around me, my glory, the One who lifts my head high.", "", "- Psalm 3:3" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be strong and take heart, all you who hope in the Lord.", "", "- Psalm 31:24" },
	{ "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", "", "- Psalm 34:18" },
	{
		"But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.",
		"",
		"- Isaiah 40:31",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "The Lord is my shepherd, I lack nothing.", "", "- Psalm 23:1" },
	{ "I can do all this through him who gives me strength.", "", "- Philippians 4:13" },
	{ "For where two or three gather in my name, there am I with them.", "", "- Matthew 18:20" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{
		"But the Lord is faithful, and he will strengthen you and protect you from the evil one.",
		"",
		"- 2 Thessalonians 3:3",
	},
	{
		"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
		"",
		"- Jeremiah 29:11",
	},
	{
		"Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
		"",
		"- Joshua 1:9",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{ "I will never leave you nor forsake you.", "", "- Hebrews 13:5" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{
		"For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
		"",
		"- John 3:16",
	},
	{ "The Lord is my shepherd; I have all that I need.", "", "- Psalm 23:1" },
	{
		"I have set the Lord always before me. Because he is at my right hand, I will not be shaken.",
		"",
		"- Psalm 16:8",
	},
	{
		"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness.",
		"",
		"- Lamentations 3:22-23",
	},
	{ "But you, Lord, are a shield around me, my glory, the One who lifts my head high.", "", "- Psalm 3:3" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be strong and take heart, all you who hope in the Lord.", "", "- Psalm 31:24" },
	{ "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", "", "- Psalm 34:18" },
	{
		"But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.",
		"",
		"- Isaiah 40:31",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "The Lord is my shepherd, I lack nothing.", "", "- Psalm 23:1" },
	{ "I can do all this through him who gives me strength.", "", "- Philippians 4:13" },
	{ "For where two or three gather in my name, there am I with them.", "", "- Matthew 18:20" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{
		"But the Lord is faithful, and he will strengthen you and protect you from the evil one.",
		"",
		"- 2 Thessalonians 3:3",
	},
	{
		"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
		"",
		"- Jeremiah 29:11",
	},
	{
		"Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
		"",
		"- Joshua 1:9",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{ "I will never leave you nor forsake you.", "", "- Hebrews 13:5" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{
		"For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
		"",
		"- John 3:16",
	},
	{ "The Lord is my shepherd; I have all that I need.", "", "- Psalm 23:1" },
	{
		"I have set the Lord always before me. Because he is at my right hand, I will not be shaken.",
		"",
		"- Psalm 16:8",
	},
	{
		"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness.",
		"",
		"- Lamentations 3:22-23",
	},
	{ "But you, Lord, are a shield around me, my glory, the One who lifts my head high.", "", "- Psalm 3:3" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be strong and take heart, all you who hope in the Lord.", "", "- Psalm 31:24" },
	{ "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", "", "- Psalm 34:18" },
	{
		"But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.",
		"",
		"- Isaiah 40:31",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{
		"The Lord is my rock, my fortress and my deliverer; my God is my rock, in whom I take refuge, my shield and the horn of my salvation, my stronghold.",
		"",
		"- Psalm 18:2",
	},
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "The Lord is my shepherd, I lack nothing.", "", "- Psalm 23:1" },
	{ "I can do all this through him who gives me strength.", "", "- Philippians 4:13" },
	{ "For where two or three gather in my name, there am I with them.", "", "- Matthew 18:20" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{
		"But the Lord is faithful, and he will strengthen you and protect you from the evil one.",
		"",
		"- 2 Thessalonians 3:3",
	},
	{
		"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.",
		"",
		"- Jeremiah 29:11",
	},
	{
		"Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.",
		"",
		"- Joshua 1:9",
	},
	{
		"The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?",
		"",
		"- Psalm 27:1",
	},
	{ "The name of the Lord is a strong tower; the righteous run to it and are safe.", "", "- Proverbs 18:10" },
	{ "I will never leave you nor forsake you.", "", "- Hebrews 13:5" },
	{ "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", "", "- Psalm 28:7" },
	{ "Be still, and know that I am God.", "", "- Psalm 46:10" },
	{ "Faith is the bird that feels the light and sings when the dawn is still dark.", "", "- Rabindranath Tagore" },
}

--- @return table
--- @param opts number|table? optional
--- returns an array of strings
local main = function(opts)
	local options = {
		max_width = 54,
		quote_list = quote_list,
	}

	if type(opts) == "number" then
		options.max_width = opts
	elseif type(opts) == "table" then
		options = vim.tbl_extend("force", options, opts)
	end

	local quote = get_quote(options.quote_list)
	local formatted_quote = format_quote(quote, options.max_width)

	return formatted_quote
end

return main
