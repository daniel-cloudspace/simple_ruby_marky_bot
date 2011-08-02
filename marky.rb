require 'yaml'

if File.exist? 'brain.yaml'
  @brain = YAML::load open('brain.yaml').read
else
  @brain = {}
end

def learn(words)
  links = words.each_cons(2).map {|p| p} 
  links.each do |word1, word2|
    @brain[word1] ||= []
    @brain[word1].push word2
  end
  endword = words.last
  @brain[endword] ||= []
  @brain[endword].push nil 
end

def generate_text(word)
    chain = []
    while not word.nil?
        chain.push(word)
        if @brain.has_key? word
            word = @brain[word].sample
        else
            word = nil
        end
    end
    return chain.join ' ' 
end

open('shortbible.txt').readlines.each {|l| learn( l.split ' ' )}

print '>> '
while sentence = gets.chomp
  break if sentence == 'q'
  words = sentence.split(' ')
  learn(words)
  @brain.each { |w| p w }
  puts "# " + generate_text(words.sample)
  print '>> '
end

open('brain.yaml', 'w') do |f| 
  f.write YAML::dump(@brain)
end
