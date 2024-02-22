.onAttach <- function(libname, pkgname) {
  # Updated list of quotes with new selections for ASAP Rocky and John Lennon
  quotes <- c(
    "\n 'Imagination is more important than knowledge. For knowledge is limited, whereas imagination embraces the entire world, stimulating progress, giving birth to evolution.' - Albert Einstein",
    "\n 'Peace is not something you wish for; it's something you make, something you do, something you are, and something you give away.' - John Lennon",
    "\n 'The most important thing is to try and inspire people so that they can be great in whatever they want to do.' - Kobe Bryant",
    "\n 'The better you are at surrounding yourself with people of high potential, the greater your chance for success.' - Jay Z",
    "\n 'This is not a time to despair, but to act.' - David Byrne",
    "\n 'The people that have the best life are the ones that are OK with not being sure.' - Mac Miller",
    "\n 'Just because you make a good plan, doesn't mean that's what's gonna happen.' - Taylor Swift",
    "\n 'The only way to do great work is to love what you do.' - Steve Jobs",
    "\n 'Genius is the ability to put into effect what is on your mind.' - Ab-Soul",
    "\n 'I'm always looking for something different. I'm inspired by the unknown.' - ASAP Rocky",
    "\n 'Life's a puzzle, all the pieces don't fit. But I'll make them fit, even if I gotta trim a bit.' - ASAP Rocky",
    "\n 'I don't want you to protest because I'm asking you to. Do it because you see a need to. Do it because you believe that the structural problems in our society need change.' - Killer Mike",
    "\n 'You have to be comfortable with being uncomfortable if you're going to grow.' - Killer Mike",
    "\n 'It's cool to be a part of the system and use your voice within it to try to make things better.' - Killer Mike",
    "\n 'At the end of the day, I just do what I do and hope that I'm not a terrible person.' - El-P",
    "\n 'Music is my way of communicating about the world, about the human condition from my perspective.' - El-P",
    "\n 'I believe in the idea that art can help to create a more empathetic and kinder world.' - El-P",

    "\n 'It’s likely that machines will be smarter than us before the end of the century—not just at chess or trivia questions but at just about everything, from mathematics and engineering to science and medicine.' - Gary Marcus",
    "\n 'Our intelligence is what makes us human, and AI is an extension of that quality.' - Yann LeCun",
    "\n 'As a technologist, I see how AI and the fourth industrial revolution will impact every aspect of people’s lives.' - Fei-Fei Li",
    "\n 'AI will probably most likely lead to the end of the world, but in the meantime, there'll be great companies.' - Sam Altman",
    "\n 'The real risk with AI isn't malice but competence. A superintelligent AI will be extremely good at accomplishing its goals, and if those goals aren't aligned with ours, we're in trouble.' - Stephen Hawking",
    "\n 'I have always been convinced that the only way to get artificial intelligence to work is to do the computation in a way similar to the human brain.' - Geoffrey Hinton",
    "\n 'The new spring in AI is the most significant development in computing in my lifetime.' - Sergey Brin",
    "\n 'You want to know how super-intelligent cyborgs might treat ordinary flesh-and-blood humans? Better start by investigating how humans treat their less intelligent animal cousins.' - Yuval Noah Harari",
    "\n 'If we do it right, we might actually be able to evolve a form of work that taps into our uniquely human capabilities and restores our humanity.' - John Hagel",
    "\n 'I am in the camp that is concerned about super intelligence.' - Bill Gates"

  )

  # Select a random quote from the list
  selected_quote <- sample(quotes, 1)

  # Display the selected quote as the package startup message
  packageStartupMessage(selected_quote)
}

