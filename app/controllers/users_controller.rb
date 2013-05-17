class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to :action => "show" , :name => @user.name
      @user.destroy
    else
      render 'new'
    end
  end

  def full

    @users = Array.new
    tagwiseScore = {}
    API::StackOverflow.API_KEY= "ufAHdaczqdRiEpKqK5*8xw(("
    page = 1
    #puts "a"
    
    #id = 22656
    id = params[:id]
    if !Record.find_by_user_id(id).nil?
      @user = User.find_by_site_id(id)
      @users.push(@user)
    else
      #puts "b"
      r = Record.new
      @user = User.new
      #puts "check"
      tempskills = API::StackOverflow.get_user_tags(id)
      #puts "e"
      skills = []
      if !tempskills.nil?
        tempskills.each { |s|
          if s["count"] > 20
            skills.push s["name"]
          end
        }
      end
      #puts "f"
      #puts "check"
      tempquestion = API::StackOverflow.get_user_questions(id)
      #puts "one"
      ##puts "#{tempquestion.size} Questions"
      #puts "check"
      tempanswer = API::StackOverflow.get_user_answers(id)
      #puts "two"
      #puts "#{tempanswer.size} Answers"
      correspondingQuestions = Array.new
      qidArray = Array.new
      if !tempanswer.nil?
        tempanswer.each{ |answer|
          qidArray.push(answer["question_id"])
        }
      end
      qidArray = qidArray.uniq
      #puts "#{qidArray.size} idArray"
      #puts "#{qidArray.join(";")}"
      #puts "check"
      correspondingQuestions = API::StackOverflow.get_questions(qidArray.join(";"))
      #puts "three"
      tagMatch = {}
      for i in 1..qidArray.size
        tagMatch[qidArray[i-1]] = correspondingQuestions[i-1]["tags"]
      end

      #puts "four"
      #if correspondingQuestions.size != tempanswer.size
      #  puts qidArray
      #end
      #puts "#{correspondingQuestions.size} correspondingQuestions"
      question_array = []
      answer_array = []
      i = 0
      if !tempquestion.nil?
        while !tempquestion[i].nil? 
          temp = tempquestion[i]
          question = {}
          question["id"] = temp["question_id"]
          question["link"] = temp["link"]
          question["title"] = temp["title"]
          question["body"] = Nokogiri::HTML(temp["body"]).inner_text
          upVotes = question["up_votes"] = temp["up_vote_count"]
          question["down_votes"] = temp["down_vote_count"]
          question["score"] = temp["score"]
          if !temp["tags"].nil?
            skills  = question["tags"] = temp["tags"]
            skills.each{ |s|
              tableEntry = FinalTags.find_by_tag(s)
              if tableEntry.nil?
                break
              end
              synonyms = tableEntry.synonyms.split
              dependent = Array.new
              sup = tableEntry.super
              if !sup.nil?
                dependent = sup.split
              end
              check = 0
              synonyms.each{ |syn|
                if tagwiseScore.has_key?(syn)
                  tagwiseScore[syn]+=1*upVotes
                  dependent.each{|dep|            
                    depsynonyms = FinalTags.find_by_tag(dep).synonyms.split
                    newcheck = 0
                    depsynonyms.each{|depsyn|
                      if tagwiseScore.has_key? depsyn
                        tagwiseScore[depsyn]+=1*upVotes
                        newcheck = 1
                        break
                      end
                    }
                    if newcheck == 0
                      tagwiseScore[dep]=1*upVotes
                    end
                  }
                  check = 1
                  break
                end
              }
              if check == 0
                tagwiseScore[s]=1*upVotes
                dependent.each{|dep|
                  #if FinalTags.find_by_tag(dep).nil?
                  #  puts dep
                  #end
                  depsynonyms = FinalTags.find_by_tag(dep).synonyms.split
                  newcheck = 0
                  depsynonyms.each{|depsyn|
                    if tagwiseScore.has_key? depsyn
                      tagwiseScore[depsyn]+=1
                      newcheck = 1
                      break
                    end
                  }
                  if newcheck == 0
                    tagwiseScore[dep]=1
                  end
                }
              end
            }
          else
            question["tags"] = []
          end
          if i < 3
            question_array.push(question)    
          end      
          i+=1           
        end
      end
      #puts "five"
      i = 0
      if !tempanswer.nil?
        while !tempanswer[i].nil? 
          temp = tempanswer[i]
          answer = {}
          answer["id"] = temp["answer_id"]
          answer["link"] = temp["link"]
          answer["title"] = temp["title"]
          answer["body"] = Nokogiri::HTML(temp["body"]).inner_text
          upVotes=answer["up_votes"] = temp["up_vote_count"]
          answer["down_votes"] = temp["down_vote_count"]
          answer["score"] = temp["score"]
          if !temp["tags"].nil?
            answer["tags"] = temp["tags"]
          else
            answer["tags"] = []
          end
          skills = tagMatch[temp["question_id"]]
          if !skills.nil?
            skills.each{ |s|
              tableEntry = FinalTags.find_by_tag(s)
              if tableEntry.nil?
                break
              end
              synonyms = tableEntry.synonyms.split
              dependent = Array.new
              sup = tableEntry.super
              if !sup.nil?
                dependent = sup.split
              end
              check = 0
              synonyms.each{ |syn|
                if tagwiseScore.has_key?(syn)
                  tagwiseScore[syn]+=2*upVotes
                  dependent.each{|dep|
                    depsynonyms = FinalTags.find_by_tag(dep).synonyms.split
                    newcheck = 0
                    depsynonyms.each{|depsyn|
                      if tagwiseScore.has_key? depsyn
                        tagwiseScore[depsyn]+=2*upVotes
                        if temp["is_accepted"]
                          tagwiseScore[depsyn]+=3
                        end
                        newcheck = 1
                        break
                      end
                    }
                    if newcheck == 0
                      tagwiseScore[dep]=2*upVotes
                      if temp["is_accepted"]
                          tagwiseScore[dep]+=3
                      end
                    end
                  }
                  check = 1
                  if temp["is_accepted"]
                    tagwiseScore[syn]+=3
                  end
                  break
                end
              }
              if check == 0
                tagwiseScore[s]=2*upVotes
                if temp["is_accepted"]
                  tagwiseScore[s]=3
                end
                dependent.each{|dep|
                  if FinalTags.find_by_tag(dep).nil?
                    puts dep
                  end
                  depsynonyms = FinalTags.find_by_tag(dep).synonyms.split
                  newcheck = 0
                  depsynonyms.each{|depsyn|
                    if tagwiseScore.has_key? depsyn
                      tagwiseScore[depsyn]+=2*upVotes
                      if temp["is_accepted"]
                          tagwiseScore[depsyn]+=3
                      end
                      newcheck = 1
                      break
                    end
                  }
                  if newcheck == 0
                    tagwiseScore[dep]=2*upVotes
                    if temp["is_accepted"]
                        tagwiseScore[dep]=3
                    end
                  end
                }
              end
            }
          end
          if i < 3
            answer_array.push(answer)   
          end
          i+=1
        end
      end
      #puts "six"
      recordUser = User.find_by_site_id(id)
      recordUser.raw_score = tagwiseScore.to_json
      self.update(tagwiseScore,id)
      tagwiseScore.each{|skill,score|
        tagwiseScore[skill] = self.normalize(skill, score)
      }
      recordUser.skills = skills.join(", ")
      recordUser.question = question_array.to_json
      recordUser.answer = answer_array.to_json
      recordUser.tagwise_score = tagwiseScore.to_json
      recordUser.save
      r.user_id = id
      r.bool = true
      r.save
      @users.push(recordUser)
      #puts "seven"
    end
  end

  def show
  #Set you API_KEY over here
    @users = Array.new
    API::StackOverflow.API_KEY= "ufAHdaczqdRiEpKqK5*8xw(("
    name = params[:name]
#    name = "batman"
    page = 1
    pagesize = 30
    temp = Array.new
    entry = Query.find_by_query(name.downcase)
    if !entry.nil?
      temp = entry.user_ids.split
      idArray = Array.new
      temp.each { |id| 
        idArray.push(id.to_i)
      }
      idArray.each { |id|
        @users.push(User.find_by_site_id(id))
      }
    else
      q = Query.new
      q.query = name
      idArray = Array.new
      tempResult=API::StackOverflow.get_user_by_name(name,:page => page , :pagesize => pagesize )
      while !tempResult.nil? and page <= 3
      #  #puts "yo"
        temp = temp.concat(tempResult)
        page+=1
        tempResult=API::StackOverflow.get_user_by_name(name,:page => page , :pagesize => pagesize )
      end
      count = 0
      temp.each { |element|
        if name.length > 5
          @my_user = User.new
          @my_user.name = element["display_name"]
          @my_user.up_votes = element["up_vote_count"]
          @my_user.down_votes = element["down_vote_count"]
          @my_user.about_me = Nokogiri::HTML(element["about_me"]).inner_text
          @my_user.location = element["location"]
          @my_user.reputation = element["reputation"]
          skills = []
          tempbadges = element["badge_counts"]
          badges = []
          if !tempbadges.nil?
            badges.push(tempbadges["gold"])
            badges.push(tempbadges["silver"])
            badges.push(tempbadges["bronze"])
          end
          @my_user.badges = badges.join(" ")
          @my_user.skills = skills.join(', ')
          @my_user.site_id = element["user_id"]
          idArray.push(@my_user.site_id).to_s
          @my_user.website_url = element["website_url"]
          @my_user.profile_image = element["profile_image"]
          question_array = []
          answer_array = []
          @my_user.question = question_array.to_json
          @my_user.answer = answer_array.to_json
          if User.find_by_site_id(@my_user.site_id).nil?
            @my_user.save
          end
          @users.push @my_user
        elsif !name.match(/\s/) and name.length <= 5 and element["display_name"].downcase.split.include?(name.downcase)
          @my_user = User.new
          @my_user.name = element["display_name"]
          @my_user.up_votes = element["up_vote_count"]
          @my_user.down_votes = element["down_vote_count"]
          @my_user.about_me = Nokogiri::HTML(element["about_me"]).inner_text
          @my_user.location = element["location"]
          @my_user.reputation = element["reputation"]
          skills = []
          tempbadges = element["badge_counts"]
          badges = []
          if !tempbadges.nil?
            badges.push(tempbadges["gold"])
            badges.push(tempbadges["silver"])
            badges.push(tempbadges["bronze"])
          end
          @my_user.badges = badges.join(" ")
          @my_user.skills = skills.join(', ')
          @my_user.site_id = element["user_id"]
          idArray.push(@my_user.site_id).to_s
          @my_user.website_url = element["website_url"]
          @my_user.profile_image = element["profile_image"]
          question_array = []
          answer_array = []
          @my_user.question = question_array.to_json
          @my_user.answer = answer_array.to_json
          if User.find_by_site_id(@my_user.site_id).nil?
            @my_user.save
          end
          @users.push @my_user
        end
      }
      q.user_ids = idArray.join(" ")
      q.save
    end
  end

  def update(tagwiseScore,id)
    tagwiseScore.each{ |skill,score|
      tableEntry = MaxScoreData.find_by_skill(skill)
      if tableEntry.score < score
        synonyms = FinalTags.find_by_tag(skill).synonyms.split
        synonyms.each{|s|
          entry = MaxScoreData.find_by_skill(s)
          entry.score = score
          entry.user_id = id
          entry.save
        }
      end
    }
  end

  def correctTagwiseScore
    records =Record.all
    records.each{|r|
      user = User.find_by_site_id(r.user_id)
      tagwiseScore = JSON.load(user.tagwise_score)
      tagwiseScore.each{|skill , score|
        if score <= 4.5 and score >= 4.0
          tagwiseScore[skill] = 4.0 + (score-4.0)*2
        end
      }
      user.tagwise_score = tagwiseScore.to_json
      user.save
    }
  end

  def unnormalize(skill , score)
    max = MaxScoreData.find_by_skill(skill).score
    max = Float(max)
    max1 = 53389
    f1 = Float(5)/Float(max1)
    f2 = Float(10)/Float(max1)
    f3 = Float(40)/Float(max1)
    f4 = Float(100)/Float(max1)
    f5 = Float(400)/Float(max1)
    f6 = Float(1000)/Float(max1)
    f7 = Float(4000)/Float(max1)
    f8 = Float(50000)/Float(max1)
    if score <= 0
      ans = 0
      return ans
    elsif score <= 0.5
      ans = 2.0*score*f1*max
      return Integer(ans)
    elsif score <= 1.0
      ans = ((score - 0.5)*2.0*(f2-f1)+f1)*max
      return Integer(ans)
    elsif score <= 1.5
      ans = ((score-1)*2.0*(f3-f2)+f2)*max
      return Integer(ans)
    elsif score <= 2.25
      ans = ((score-1.5)*1.5*(f4-f3)+f3)*max
      return Integer(ans)
    elsif score <= 3.0
      ans = ((score-2.25)*1.5*(f5-f4)+f4)*max
      return Integer(ans)
    elsif score <= 3.5
      ans = ((score-3.0)*2.0*(f6-f5)+f5)*max
      return Integer(max)
    elsif score <= 4.0
      ans = ((score-3.5)*2.0*(f7-f6)+f6)*max
      return Integer(ans)
    elsif score <= 4.5
      ans = ((score-4.0)*2.0*(f8-f7)+f7)*max
      return Integer(ans)
    else
      return Integer(f8*max)
    end
  end

  def normalize(skill,score)
    max = MaxScoreData.find_by_skill(skill).score
    f = Float(score)/Float(max)
    max1 = 53389
    f1 = Float(5)/Float(max1)
    f2 = Float(10)/Float(max1)
    f3 = Float(40)/Float(max1)
    f4 = Float(100)/Float(max1)
    f5 = Float(400)/Float(max1)
    f6 = Float(1000)/Float(max1)
    f7 = Float(4000)/Float(max1)
    f8 = Float(50000)/Float(max1)
    if f <= 0
      return 0
    elsif f <= f1
      ans = 0 + 0.5*f/f1
      return ans
    elsif f <= f2
      ans = 0.5 + 0.5*(f-f1)/(f2-f1)
      return ans
    elsif f <= f3
      ans = 1 + 0.5*(f-f2)/(f3-f2)
      return ans
    elsif f <= f4
      ans = 1.5 + 0.75*(f-f3)/(f4-f3)
      return ans
    elsif f <= f5
      ans = 2.25 + 0.75*(f-f4)/(f5-f4)
      return ans
    elsif f <= f6
      ans = 3.0 + 0.5*(f-f5)/(f6-f5)
      return ans
    elsif f <= f7
      ans = 3.5 + 0.5*(f-f6)/(f7-f6)
      return ans
    elsif f <= f8
      ans = 4.0 + 1*(f-f7)/(f8-f7)
      return ans
    else
      return 5
    end
  end

  def allTags
    tags = FinalTags.all
    tags.each{ |tag|
      skill = tag.tag
      synonyms = tag.synonyms.split
      max = 0
      synonyms.each{|s|
        entry = MaxScoreData.find_by_skill(s)
        if entry.score > max
          max = entry.score
        end
      }
      synonyms.each{|s|
        entry = MaxScoreData.find_by_skill(s)
        entry.score = max
        entry.save
      }
    }
  end

  def normalizeExisting
    records = Record.all
    records.each{|r|
      user = User.find_by_site_id(r.user_id)
      score = user.tagwise_score
      score = JSON.load(score)
      score.each{|skill,sc|
        score[skill] = normalize(skill,sc)
      }
      user.tagwise_score = score.to_json
      user.save
    }
  end

  def recoverRawScore
    records = Record.all
    records.each{|r|
      user = User.find_by_site_id(r.user_id)
      normalized = JSON.load(user.tagwise_score)
      unnormalized = {}
      normalized.each{|skill , score|
        unnormalized[skill] = self.unnormalize(skill , score)
      }
      user.raw_score = unnormalized.to_json
      user.save
    }
  end

  def getMaxScoreData
    API::StackOverflow.API_KEY= "ufAHdaczqdRiEpKqK5*8xw(("
    page = 1
    while true
      users = API::StackOverflow.get_all_users(:page => page , :pagesize => 100)
      users.each{|element|
        id = element["user_id"]
        if !Record.find_by_user_id(id).nil?
          score = User.find_by_site_id(id)["tagwise_score"]
          score = JSON.load(score)
          score.each{ |tag,score|
            if score != 0
              maxScore = MaxScoreData.find_by_skill(tag)
              if maxScore.nil?
                e = MaxScoreData.new
                e.skill = tag
                e.score = score
                e.user_id = id
                e.save
                puts "OOOOOOOOOOONNNNNNNNNNNNNNNEEEEEEEEEEEEEE  UUUUUUUUUUUUUUPPPPPPPPPPPPPPPPPP"
              else
                if maxScore.score < score
                  previous = maxScore.score
                  maxScore.score = score
                  maxScore.user_id = id
                  maxScore.save
                  puts "UUUUUUUUUUUUUPPPPPPPPPPPDDDDDDDDDDDDDAAAAAAAAAAATTTTTTTTTTTEEEEEEEEEEDDDDDDDDDDDDD | #{previous} => #{score}"
                end
              end
            end
          }
        else
          if !User.find_by_site_id(id).nil?
            self.full(id)
            score = User.find_by_site_id(id)["tagwise_score"]
            score = JSON.load(score)
            score.each{ |tag,score|
              if score != 0
                maxScore = MaxScoreData.find_by_skill(tag)
                if maxScore.nil?
                  e = MaxScoreData.new
                  e.skill = tag
                  e.score = score
                  e.user_id = id
                  e.save
                  puts "OOOOOOOOOOONNNNNNNNNNNNNNNEEEEEEEEEEEEEE  UUUUUUUUUUUUUUPPPPPPPPPPPPPPPPPP"
                else
                  if maxScore.score < score
                    previous = maxScore.score
                    maxScore.score = score
                    maxScore.user_id = id
                    maxScore.save
                    puts "UUUUUUUUUUUUUPPPPPPPPPPPDDDDDDDDDDDDDAAAAAAAAAAATTTTTTTTTTTEEEEEEEEEEDDDDDDDDDDDDD | #{previous} => #{score}"
                  end
                end
              end
            }
          else
            @my_user = User.new
            @my_user.name = element["display_name"]
            @my_user.up_votes = element["up_vote_count"]
            @my_user.down_votes = element["down_vote_count"]
            @my_user.about_me = Nokogiri::HTML(element["about_me"]).inner_text
            @my_user.location = element["location"]
            @my_user.reputation = element["reputation"]
            skills = []
            tempbadges = element["badge_counts"]
            badges = []
            if !tempbadges.nil?
              badges.push(tempbadges["gold"])
              badges.push(tempbadges["silver"])
              badges.push(tempbadges["bronze"])
            end
            @my_user.badges = badges.join(" ")
            @my_user.skills = skills.join(', ')
            @my_user.site_id = id
            @my_user.website_url = element["website_url"]
            @my_user.profile_image = element["profile_image"]
            question_array = []
            answer_array = []
            @my_user.question = question_array.to_json
            @my_user.answer = answer_array.to_json
            @my_user.save
            self.full(id)
            score = User.find_by_site_id(id)["tagwise_score"]
            score = JSON.load(score)
            score.each{ |tag,score|
              if score != 0
                maxScore = MaxScoreData.find_by_skill(tag)
                if maxScore.nil?
                  e = MaxScoreData.new
                  e.skill = tag
                  e.score = score
                  e.user_id = id
                  e.save
                  puts "OOOOOOOOOOONNNNNNNNNNNNNNNEEEEEEEEEEEEEE  UUUUUUUUUUUUUUPPPPPPPPPPPPPPPPPP"
                else
                  if maxScore.score < score
                    previous = maxScore.score
                    maxScore.score = score
                    maxScore.user_id = id
                    maxScore.save
                    puts "UUUUUUUUUUUUUPPPPPPPPPPPDDDDDDDDDDDDDAAAAAAAAAAATTTTTTTTTTTEEEEEEEEEEDDDDDDDDDDDDD | #{previous} => #{score}"
                  end
                end
              end
            }
          end
        end
      }
      page+=1
    end
  end

  def generateTagDatabase
    API::StackOverflow.API_KEY= "ufAHdaczqdRiEpKqK5*8xw(("
    pagesize = 30
    tags = Array.new
    for page in 1..57
      tags = tags + API::StackOverflow.get_tags( :page => page , :pagesize => pagesize)
    end
    tags.each{ |tempTag|
      t = Tag.new
      t.tag = tempTag["name"]
      if tempTag["has_synonyms"]
        t.synonyms = API::StackOverflow.get_tag_synonyms(CGI::escape(t.tag))
      else
        t.synonyms = nil
      end
      t.save
    }
  end

  def modifyTags
    tags = FinalTags.all
    problems = Array.new
    found = Array.new
    tags.each{ |tag|
      extra = Array.new
      if !tag.super.nil?
        extra = tag.super.split
      end
      extra.each{ |e|
        if FinalTags.find_by_tag(e).nil?
          newtag = FinalTags.new
          newtag.tag = e
          newtag.synonyms = e
          if newtag.save
            puts "good"
          else
            problems.push(newtag)
          end
          found.push(newtag)
        end
      }
    }
    puts "problems: count | #{problems} : #{problems.size}"
    puts "found : count | #{found} : #{found.size}"
  end



  def giveScore
    users = UserData.all
    users.each{ |userdata|
      user = JSON.load(userdata.user)
      r = Record.new
      r.user_id = user["user_id"]
      r.bool = true

    }
  end

  def normalization
    API::StackOverflow.API_KEY= "ufAHdaczqdRiEpKqK5*8xw(("
    data = Array.new
    for i in 1..100
      ids = Array.new
      for count in 1..100
        ids.push(rand(2385191))
      end
      query = API::StackOverflow.get_users(ids,  :page => 1, :pagesize => 100)
      puts ids.size
      if !query.nil?
        puts query.size
      end
      puts "got #{i}"
      if !query.nil?
        data += query
      end
    end
    data.each{ |user|
      newuser = UserData.new
      newuser.reputation = user["reputation"]
      newuser.user = user.to_json
      newuser.save
    }
  end

  def giveData
    data = UserData.all
    count = 0
    found = 0
    data.each{ |d|
      if count%100 == 0
        puts "#{d.reputation} : #{d.value}"
        found += 1
        if found == 40
          break
        end
      end
      count += 1
    }
  end

  def modifyData
    data = UserData.all
    data.each{ |d|
      repo = d.reputation
      if repo <= 0
        d.value = 0
        d.save
      elsif repo <= 5
        d.value = 0.0 + 0.5*Float(repo)/5.0
        d.save
      elsif repo <= 10
        d.value = 0.5 + 0.5*Float(repo - 5.0)/5.0
        d.save
      elsif repo <= 40
        d.value = 1.0 + 1.0*Float(repo - 10)/30.0
        d.save
      elsif repo <= 100
        d.value = 2.0 + 0.75*Float(repo - 40)/60.0
        d.save
      elsif repo <= 400
        d.value = 2.75 + 0.75*Float(repo - 100)/300.0
        d.save
      elsif repo <= 1000
        d.value = 3.5 + 0.5*Float(repo - 400)/600.0
        d.save
      elsif repo <= 4000
        d.value = 4.0 + 0.5*Float(repo - 1000)/3000.0
        d.save
      else
        d.value = 4.5 + 0.5*Float(repo - 4000)/49390.0
        d.save
      end
    }
  end

  def generateScore
    API::StackOverflow.API_KEY= "ufAHdaczqdRiEpKqK5*8xw(("
    userqa = {}
    data = UserData.all
    idArray = Array.new
    data[0..1050].each{ |d|
      id = JSON.load(d.user)["user_id"]
      d.user_id = id
      d.save
      if User.find_by_site_id(id).nil?
        idArray.push(id)
      end
      if idArray.size == 100
        puts "AAYA"
        users = API::StackOverflow.get_users(idArray, :page => 1,:pagesize =>100)
        users.each{ |element|
          @my_user = User.new
          @my_user.name = element["display_name"]
          @my_user.up_votes = element["up_vote_count"]
          @my_user.down_votes = element["down_vote_count"]
          @my_user.about_me = Nokogiri::HTML(element["about_me"]).inner_text
          @my_user.location = element["location"]
          @my_user.reputation = element["reputation"]
          skills = []
          tempbadges = element["badge_counts"]
          badges = []
          if !tempbadges.nil?
            badges.push(tempbadges["gold"])
            badges.push(tempbadges["silver"])
            badges.push(tempbadges["bronze"])
          end
          @my_user.badges = badges.join(" ")
          @my_user.skills = skills.join(', ')
          @my_user.site_id = element["user_id"]
          @my_user.website_url = element["website_url"]
          @my_user.profile_image = element["profile_image"]
          question_array = []
          answer_array = []
          @my_user.question = question_array.to_json
          @my_user.answer = answer_array.to_json
          if @my_user.save
            puts "good"
          else
            puts "duplicate"
          end
          puts "Ghusa"
          self.full(element["user_id"])
          puts "Nikla"
        }
        idArray.clear
        puts "HUWA"
      end
    }
  end

  def getJavaData
    data = UserDa
  end

  def java
    API::StackOverflow.API_KEY= "ufAHdaczqdRiEpKqK5*8xw(("
    data = UserData.all
    i = 0
    pick = Array.new
    javaScore = Array.new
    data.each{|d|
      if i%100==8
        pick.push(d)
      end
      i+=1
    }

    pick.each{|p|
      id = p.user_id
      if id.nil?
        id = JSON.load(p.user)["user_id"]
      end
      score = {}
      recordEntry = Record.find_by_user_id(id)
      userEntry = User.find_by_site_id(id)
      if !recordEntry.nil?
        score = userEntry["tagwise_score"]
      else
        if !userEntry.nil?
          self.full(id)
          score = User.find_by_site_id(id)["tagwise_score"]
        else
          element = API::StackOverflow.get_user(id)
          @my_user = User.new
          @my_user.name = element["display_name"]
          @my_user.up_votes = element["up_vote_count"]
          @my_user.down_votes = element["down_vote_count"]
          @my_user.about_me = Nokogiri::HTML(element["about_me"]).inner_text
          @my_user.location = element["location"]
          @my_user.reputation = element["reputation"]
          skills = []
          tempbadges = element["badge_counts"]
          badges = []
          if !tempbadges.nil?
            badges.push(tempbadges["gold"])
            badges.push(tempbadges["silver"])
            badges.push(tempbadges["bronze"])
          end
          @my_user.badges = badges.join(" ")
          @my_user.skills = skills.join(', ')
          @my_user.site_id = element["user_id"]
          
          @my_user.website_url = element["website_url"]
          @my_user.profile_image = element["profile_image"]
          question_array = []
          answer_array = []
          @my_user.question = question_array.to_json
          @my_user.answer = answer_array.to_json
          if @my_user.save
            puts "good"
          else
            puts "problem"
          end
          self.full(id)
          score = User.find_by_site_id(id)["tagwise_score"]
        end
      end
      score = JSON.load(score)
      if score.nil?
        puts id
      end
      if !score["java"].nil?
        javaScore.push(score["java"])
      end
      puts javaScore.size
    }
  end

end

