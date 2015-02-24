class FakeAccount
  define_method(:id)         { 1 }
  define_method(:name)       { "Adam" }
  define_method(:bio)        { nil }
  define_method(:fake_posts) { [FakePost.new] }
  define_method(:sex)        { "Male" }
end

class FakeAccountRepresenter < Last::Representers::Representer
  expose :id,         :property,     in: :summary, as: :integer
  expose :name,       :property,     in: :summary, as: [:string, :null]
  expose :bio,        :property,     in: :detail,  as: [:string, :null], required: false
  expose :fake_posts, :relationship, in: :detail,  with: :detail, list: true, using: -> { FakePostRepresenter }
  expose :sex,        :property,     in: :full,    as: [:string]

  # Expected JSON Schemas
  #
  def self.expected_json_schema_in_summary
    {
      additionalProperties: false,
      type:     [:object, :null],
      required: [:id, :name],
      properties: {
        id:   {type: [:integer]},
        name: {type: [:string, :null]}
      }
    }
  end

  def self.expected_json_schema_in_detail
    {
      additionalProperties: false,
      type:     [:object, :null],
      required: [:id, :name, :fake_posts],
      properties: {
        id:   {type: [:integer]},
        name: {type: [:string, :null]},
        bio:  {type: [:string, :null]},
        fake_posts: {
          type: [:array, :null],
          items: FakePostRepresenter.expected_json_schema_in_detail
        }
      }
    }
  end

  def self.expected_json_schema_in_full
    {
      additionalProperties: false,
      type:     [:object, :null],
      required: [:id, :name, :fake_posts, :sex],
      properties: {
        id:   {type: [:integer]},
        name: {type: [:string, :null]},
        bio:  {type: [:string, :null]},
        fake_posts: {
          type: [:array, :null],
          items: FakePostRepresenter.expected_json_schema_in_detail
        },
        sex:  {type: [:string]}
      }
    }
  end
end

class FakeAdmin < FakeAccount
  define_method(:role) { "admin" }

  define_method(:nil_relationship)  { nil }
  define_method(:nil_relationships) { nil }
end

class FakeAdminRepresenter < FakeAccountRepresenter
  expose :role, :property, in: :summary, as: [:string, :null]

  expose :nil_relationship,  :relationship, in: :summary, using: -> { NilRelationshipRepresenter }
  expose :nil_relationships, :relationship, in: :summary, using: -> { NilRelationshipRepresenter }, list: true

  # Expected JSON Schemas
  #
  def self.expected_json_schema_in_summary
    {
      additionalProperties: false,
      type:     [:object, :null],
      required: [:id, :name, :role, :nil_relationship, :nil_relationships],
      properties: {
        id:   {type: [:integer]},
        name: {type: [:string, :null]},
        role: {type: [:string, :null]},
        nil_relationship: NilRelationshipRepresenter.expected_json_schema_in_summary,
        nil_relationships: {
          type: [:array, :null],
          items: NilRelationshipRepresenter.expected_json_schema_in_summary
        },
      }
    }
  end
end

class FakePost
  define_method(:id)            { 1 }
  define_method(:title)         { "Post Title" }
  define_method(:body)          { nil }
  define_method(:fake_comments) { [FakeComment.new] }
end

class FakePostRepresenter < Last::Representers::Representer
  expose :id,            :property,     in: :summary, as: :integer
  expose :title,         :property,     in: :summary, as: [:string, :null]
  expose :body,          :property,     in: :summary, as: [:string, :null]

  expose :fake_comments, :relationship, in: :detail, with: :detail, required: false, using: -> { FakeCommentRepresenter }, list: true

  # Expected JSON Schemas
  #
  def self.expected_json_schema_in_detail
    {
      additionalProperties: false,
      type:     [:object, :null],
      required: [:id, :title, :body],
      properties: {
        id:    {type: [:integer]},
        title: {type: [:string, :null]},
        body:  {type: [:string, :null]},
        fake_comments: {
          type: [:array, :null],
          items: FakeCommentRepresenter.expected_json_schema_in_detail
        }
      }
    }
  end
end

class FakeComment
  define_method(:id)              { 1 }
  define_method(:body)            { nil }
  define_method(:fake_account_id) { 1 }
  define_method(:fake_author)     { FakeAccount.new }
end

class FakeCommentRepresenter < Last::Representers::Representer
  expose :id,              :property,     in: :summary, as: :integer
  expose :body,            :property,     in: :summary, as: [:string, :null]
  expose :fake_account_id, :property,     in: :summary, as: [:integer, :null]
  expose :fake_author,     :relationship, in: :summary, using: -> { FakeAccountRepresenter }

  # Expected JSON Schemas
  #
  def self.expected_json_schema_in_detail
    {
      additionalProperties: false,
      type:     [:object, :null],
      required: [:id, :body, :fake_account_id, :fake_author],
      properties: {
        id:              {type: [:integer]},
        body:            {type: [:string, :null]},
        fake_account_id: {type: [:integer, :null]},
        fake_author:     FakeAccountRepresenter.expected_json_schema_in_summary
      }
    }
  end
end

class NilRelationshipRepresenter < Last::Representers::Representer
  expose :id, :property, in: :summary, as: [:integer]

  def self.expected_json_schema_in_summary
    {
      additionalProperties: false,
      type:     [:object, :null],
      required: [:id],
      properties: {
        id: {type: [:integer]}
      }
    }
  end
end
