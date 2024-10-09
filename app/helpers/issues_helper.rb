module IssuesHelper
  def all_images(answers)
    answers.flat_map do |answer|
      if answer.images.attached?
        answer.images.map do |image|
          { image: image, author: answer.member.display_name, content: answer.content }
        end
      else
        []
      end
    end
  end
end
