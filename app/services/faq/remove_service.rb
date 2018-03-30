module FaqModule
  class RemoveService
    def initialize(params)
      # TODO: identify origin and set company
      @company = Company.last
      @params = params
      @id = params['id']
    end

    def call
      faq = @company.faqs.where(id: @id).last
      return 'Questão inválida, verifique o ID' if faq == nil

      Faq.transaction do
        # Deleta as tags associadas que não estejam associadas a outras faqs
        faq.hashtags.each do |h|
          h.delete if h.faqs.count <= 1
        end
      end
      faq.delete
      'Deletado com sucesso'
    end
  end
end
