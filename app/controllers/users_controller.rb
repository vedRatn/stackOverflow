class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to :action => "show" , :name => @user.name
    else
      render 'new'
    end
  end

  def full
    @users = Array.new
    tagwiseScore = {}
    API::StackOverflow.API_KEY= "ufAHdaczqdRiEpKqK5*8xw(("
    page = 1
    pagesize = 30
    id = params[:id]
    if !Record.find_by_user_id(id).nil?
      @user = User.find_by_site_id(id)
      @users.push(@user)
    else
      r = Record.new
      @user = User.new
      temp = API::StackOverflow.get_user(id)
      @user.name = temp["display_name"]
      @user.up_votes = temp["up_vote_count"]
      @user.down_votes = temp["down_vote_count"]
      tempbadges = temp["badge_counts"]
      badges = []
      if !tempbadges.nil?
        badges.push(tempbadges["gold"])
        badges.push(tempbadges["silver"])
        badges.push(tempbadges["bronze"])
      end
      @user.badges = badges.join(" ")
      @user.profile_image = temp["profile_image"]
      @user.website_url = temp["website_url"]
      @user.location = temp["location"]
      @user.reputation = temp["reputation"]
      @user.site_id = temp["user_id"]
      tempskills = API::StackOverflow.get_user_tags(id)
      skills = []
      if !tempskills.nil?
        tempskills.each { |s|
          if s["count"] > 30
            skills.push s["name"]
          end
        }
      end
      tempquestion = API::StackOverflow.get_user_questions(id)
      tempanswer = API::StackOverflow.get_user_answers(id)
      question_array = []
      answer_array = []
      if !tempquestion.nil?
        for i in 0..2
          if !tempquestion[i].nil?
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
              skills = question["tags"] = temp["tags"]
              skills = self.minimise(skills)
              skills.each{ |s|
                if tagwiseScore.has_key?(s)
                  tagwiseScore[s]+=5*upVotes
                else
                  tagwiseScore[s]=5*upVotes
                end
              }
            else
              question["tags"] = []
            end
            question_array.push(question)            
          end
        end
      end
      if !tempanswer.nil?
       for i in 0..2
          if !tempanswer[i].nil?
            temp = tempanswer[i]
            answer = {}
            answer["id"] = temp["question_id"]
            answer["link"] = temp["link"]
            answer["title"] = temp["title"]
            answer["body"] = Nokogiri::HTML(temp["body"]).inner_text
            answer["up_votes"] = temp["up_vote_count"]
            answer["down_votes"] = temp["down_vote_count"]
            answer["score"] = temp["score"]
            if !temp["tags"].nil?
              answer["tags"] = temp["tags"]
            else
              answer["tags"] = []
            end     
           answer_array.push(answer)
          end       
        end
      end
      @user.skills = skills.join(", ")
      @user.question = question_array.to_json
      @user.answer = answer_array.to_json
      recordUser = User.find_by_site_id(id)
      recordUser.skills = @user.skills
      recordUser.question = @user.question
      recordUser.answer = @user.answer
      recordUser.save
      r.user_id = id
      r.bool = true
      r.save
      @users.push(@user)
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
      #  puts "yo"
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

  def generateTagDatabase
    
  end
end




