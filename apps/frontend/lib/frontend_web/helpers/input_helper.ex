defmodule FrontendWeb.InputHelper do
  use Phoenix.HTML

  def input(form, field, opts \\ []) do
    type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)

    wrapper_opts = [class: "form-group #{state_class(form, field)}"]
    label_opts = [class: "control-label"]
    input_opts = [class: "bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-indigo-700 w-full"]

    #content_tag :div, wrapper_opts do
      #label = label(form, field, humanize(field), label_opts)
      input = input(type, form, field, input_opts)
      #error = nil # YourApp.ErrorHelpers.error_tag(form, field)
      #[label, input, error || ""]
    #end
  end

  defp state_class(form, field) do
    cond do
      # The form was not yet submitted
      !form.source.action -> ""
      form.errors[field] -> "has-error"
      true -> "has-success"
    end
  end

  # Implement clauses below for custom inputs.
  # defp input(:datepicker, form, field, input_opts) do
  #   raise "not yet implemented"
  # end

  defp input("lang_string", form, field, input_opts) do
    values = Phoenix.HTML.Form.input_value(form, field) || [""]
    Enum.map(values, fn(val) ->
      {language, value} = values(val)

      content_tag :div, class: "flex w-full mb-2 items-top" do
        #Graph.Struct.Language.find(:code, language).name
        [content_tag(:div, Graph.Struct.Language.find(:code, language).name, class: "w-1/3 font-medium leading-snug"),
        content_tag :div, class: "flex-1 pl-8" do
          input_opts2 = [
            name: Phoenix.HTML.Form.input_name(form, field) <> "[#{language}]",
            value: value
          ]
          apply(Phoenix.HTML.Form, :text_input, [form, field, input_opts ++ input_opts2])
        end]
      end


    end)
  end

  defp input("lang_text", form, field, input_opts) do
    values = Phoenix.HTML.Form.input_value(form, field) || [""]
    Enum.map(values, fn(val) ->
      {language, value} = values(val)

      content_tag :div, class: "flex w-full mb-2 items-top" do
       [content_tag(:div, Graph.Struct.Language.find(:code, language).name, [class: "w-1/3 font-medium leading-snug"]),
        content_tag :div, class: "flex-1 pl-8" do
          input_opts2 = [
            name: Phoenix.HTML.Form.input_name(form, field) <> "[#{language}]",
            value: value
          ]
          apply(Phoenix.HTML.Form, :textarea, [form, field, input_opts ++ input_opts2])
        end]
      end


    end)
  end

  defp values(%Dlex.Lang{value: value, language: language}), do: {language, value}
  defp values({language, value}), do: {language, value}

  defp input(type, form, field, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end
end
