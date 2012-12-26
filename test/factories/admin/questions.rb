FactoryGirl.define do
  factory :question, class: Admin::Question do
    question_text :random_text
    response_type { ['Short Text', 'Long Text', 'Number', 'Yes/No', 'File'].sample }

    ignore do
      answered   { [true, false].sample }
      answerable nil
    end

    after(:create) do |question, evaluator|
      if evaluator.answered
        FactoryGirl.create(:answer, question_id: question.id, response_type: question.response_type, answerable: evaluator.answerable)
      end
    end
  end
end