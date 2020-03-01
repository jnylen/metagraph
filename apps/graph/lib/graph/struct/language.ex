defmodule Graph.Struct.Language do
  defstruct code: nil, name: nil, country: nil

  @moduledoc """
  The struct and helper for Language tags (i.e. sv-SE).
  """

  @list [
    %{
      code: "af-ZA",
      country: "ZA",
      name: "Afrikaans (South Africa)"
    },
    %{
      code: "ar-AE",
      country: "AE",
      name: "Arabic (U.A.E.)"
    },
    %{
      code: "ar-BH",
      country: "BH",
      name: "Arabic (Bahrain)"
    },
    %{
      code: "ar-DZ",
      country: "DZ",
      name: "Arabic (Algeria)"
    },
    %{
      code: "ar-EG",
      country: "EG",
      name: "Arabic (Egypt)"
    },
    %{
      code: "ar-IQ",
      country: "IQ",
      name: "Arabic (Iraq)"
    },
    %{
      code: "ar-JO",
      country: "JO",
      name: "Arabic (Jordan)"
    },
    %{
      code: "ar-KW",
      country: "KW",
      name: "Arabic (Kuwait)"
    },
    %{
      code: "ar-LB",
      country: "LB",
      name: "Arabic (Lebanon)"
    },
    %{
      code: "ar-LY",
      country: "LY",
      name: "Arabic (Libya)"
    },
    %{
      code: "ar-MA",
      country: "MA",
      name: "Arabic (Morocco)"
    },
    %{
      code: "ar-OM",
      country: "OM",
      name: "Arabic (Oman)"
    },
    %{
      code: "ar-QA",
      country: "QA",
      name: "Arabic (Qatar)"
    },
    %{
      code: "ar-SA",
      country: "SA",
      name: "Arabic (Saudi Arabia)"
    },
    %{
      code: "ar-SY",
      country: "SY",
      name: "Arabic (Syria)"
    },
    %{
      code: "ar-TN",
      country: "TN",
      name: "Arabic (Tunisia)"
    },
    %{
      code: "ar-YE",
      country: "YE",
      name: "Arabic (Yemen)"
    },
    %{
      code: "az-Cyrl-AZ",
      country: "AZ",
      name: "Azeri (Cyrillic, Azerbaijan)"
    },
    %{
      code: "az-Latn-AZ",
      country: "AZ",
      name: "Azeri (Latin, Azerbaijan)"
    },
    %{
      code: "be-BY",
      country: "BY",
      name: "Belarusian (Belarus)"
    },
    %{
      code: "bg-BG",
      country: "BG",
      name: "Bulgarian (Bulgaria)"
    },
    %{
      code: "bs-Latn-BA",
      country: "BA",
      name: "Bosnian (Bosnia and Herzegovina)"
    },
    %{
      code: "ca-ES",
      country: "ES",
      name: "Catalan (Catalan)"
    },
    %{
      code: "cs-CZ",
      country: "CZ",
      name: "Czech (Czech Republic)"
    },
    %{
      code: "cy-GB",
      country: "GB",
      name: "Welsh (United Kingdom)"
    },
    %{
      code: "da-DK",
      country: "DK",
      name: "Danish (Denmark)"
    },
    %{
      code: "de-AT",
      country: "AT",
      name: "German (Austria)"
    },
    %{
      code: "de-DE",
      country: "DE",
      name: "German (Germany)"
    },
    %{
      code: "de-CH",
      country: "CH",
      name: "German (Switzerland)"
    },
    %{
      code: "de-LI",
      country: "LI",
      name: "German (Liechtenstein)"
    },
    %{
      code: "de-LU",
      country: "LU",
      name: "German (Luxembourg)"
    },
    %{
      code: "dv-MV",
      country: "MV",
      name: "Divehi (Maldives)"
    },
    %{
      code: "el-GR",
      country: "GR",
      name: "Greek (Greece)"
    },
    %{
      code: "en-029",
      country: nil,
      name: "English (Caribbean)"
    },
    %{
      code: "en-AU",
      country: "AU",
      name: "English (Australia)"
    },
    %{
      code: "en-BZ",
      country: "BZ",
      name: "English (Belize)"
    },
    %{
      code: "en-CA",
      country: "CA",
      name: "English (Canada)"
    },
    %{
      code: "en-GB",
      country: "GB",
      name: "English (United Kingdom)"
    },
    %{
      code: "en-IE",
      country: "IE",
      name: "English (Ireland)"
    },
    %{
      code: "en-JM",
      country: "JM",
      name: "English (Jamaica)"
    },
    %{
      code: "en-NZ",
      country: "NZ",
      name: "English (New Zealand)"
    },
    %{
      code: "en-PH",
      country: "PH",
      name: "English (Republic of the Philippines)"
    },
    %{
      code: "en-TT",
      country: "TT",
      name: "English (Trinidad and Tobago)"
    },
    %{
      code: "en-US",
      country: "US",
      name: "English (United States)"
    },
    %{
      code: "en-ZA",
      country: "ZA",
      name: "English (South Africa)"
    },
    %{
      code: "en-ZW",
      country: "ZW",
      name: "English (Zimbabwe)"
    },
    %{
      code: "es-AR",
      country: "AR",
      name: "Spanish (Argentina)"
    },
    %{
      code: "es-BO",
      country: "BO",
      name: "Spanish (Bolivia)"
    },
    %{
      code: "es-CL",
      country: "CL",
      name: "Spanish (Chile)"
    },
    %{
      code: "es-CO",
      country: "CO",
      name: "Spanish (Colombia)"
    },
    %{
      code: "es-CR",
      country: "CR",
      name: "Spanish (Costa Rica)"
    },
    %{
      code: "es-DO",
      country: "DO",
      name: "Spanish (Dominican Republic)"
    },
    %{
      code: "es-EC",
      country: "EC",
      name: "Spanish (Ecuador)"
    },
    %{
      code: "es-ES",
      country: "ES",
      name: "Spanish (Spain)"
    },
    %{
      code: "es-GT",
      country: "GT",
      name: "Spanish (Guatemala)"
    },
    %{
      code: "es-HN",
      country: "HN",
      name: "Spanish (Honduras)"
    },
    %{
      code: "es-MX",
      country: "MX",
      name: "Spanish (Mexico)"
    },
    %{
      code: "es-NI",
      country: "NI",
      name: "Spanish (Nicaragua)"
    },
    %{
      code: "es-PA",
      country: "PA",
      name: "Spanish (Panama)"
    },
    %{
      code: "es-PE",
      country: "PE",
      name: "Spanish (Peru)"
    },
    %{
      code: "es-PR",
      country: "PR",
      name: "Spanish (Puerto Rico)"
    },
    %{
      code: "es-PY",
      country: "PY",
      name: "Spanish (Paraguay)"
    },
    %{
      code: "es-SV",
      country: "SV",
      name: "Spanish (El Salvador)"
    },
    %{
      code: "es-UY",
      country: "UY",
      name: "Spanish (Uruguay)"
    },
    %{
      code: "es-VE",
      country: "VE",
      name: "Spanish (Venezuela)"
    },
    %{
      code: "et-EE",
      country: "EE",
      name: "Estonian (Estonia)"
    },
    %{
      code: "eu-ES",
      country: "ES",
      name: "Basque (Basque)"
    },
    %{
      code: "fa-IR",
      country: "IR",
      name: "Persian (Iran)"
    },
    %{
      code: "fi-FI",
      country: "FI",
      name: "Finnish (Finland)"
    },
    %{
      code: "fo-FO",
      country: "FO",
      name: "Faroese (Faroe Islands)"
    },
    %{
      code: "fr-BE",
      country: "BE",
      name: "French (Belgium)"
    },
    %{
      code: "fr-CA",
      country: "CA",
      name: "French (Canada)"
    },
    %{
      code: "fr-FR",
      country: "FR",
      name: "French (France)"
    },
    %{
      code: "fr-CH",
      country: "CH",
      name: "French (Switzerland)"
    },
    %{
      code: "fr-LU",
      country: "LU",
      name: "French (Luxembourg)"
    },
    %{
      code: "fr-MC",
      country: "MC",
      name: "French (Principality of Monaco)"
    },
    %{
      code: "gl-ES",
      country: "ES",
      name: "Galician (Galician)"
    },
    %{
      code: "gu-IN",
      country: "IN",
      name: "Gujarati (India)"
    },
    %{
      code: "he-IL",
      country: "IL",
      name: "Hebrew (Israel)"
    },
    %{
      code: "hi-IN",
      country: "IN",
      name: "Hindi (India)"
    },
    %{
      code: "hr-BA",
      country: "BA",
      name: "Croatian (Bosnia and Herzegovina)"
    },
    %{
      code: "hr-HR",
      country: "HR",
      name: "Croatian (Croatia)"
    },
    %{
      code: "hu-HU",
      country: "HU",
      name: "Hungarian (Hungary)"
    },
    %{
      code: "hy-AM",
      country: "AM",
      name: "Armenian (Armenia)"
    },
    %{
      code: "id-ID",
      country: "ID",
      name: "Indonesian (Indonesia)"
    },
    %{
      code: "is-IS",
      country: "IS",
      name: "Icelandic (Iceland)"
    },
    %{
      code: "it-CH",
      country: "CH",
      name: "Italian (Switzerland)"
    },
    %{
      code: "it-IT",
      country: "IT",
      name: "Italian (Italy)"
    },
    %{
      code: "ja-JP",
      country: "JP",
      name: "Japanese (Japan)"
    },
    %{
      code: "ka-GE",
      country: "GE",
      name: "Georgian (Georgia)"
    },
    %{
      code: "kk-KZ",
      country: "KZ",
      name: "Kazakh (Kazakhstan)"
    },
    %{
      code: "kn-IN",
      country: "IN",
      name: "Kannada (India)"
    },
    %{
      code: "kok-IN",
      country: "IN",
      name: "Konkani"
    },
    %{
      code: "kok-IN",
      country: "IN",
      name: "Konkani (India)"
    },
    %{
      code: "ko-KR",
      country: "KR",
      name: "Korean (South Korea)"
    },
    %{
      code: "ko-KP",
      country: "KP",
      name: "Korean (North Korea)"
    },
    %{
      code: "ky-KG",
      country: "KG",
      name: "Kyrgyz (Kyrgyzstan)"
    },
    %{
      code: "lt-LT",
      country: "LT",
      name: "Lithuanian (Lithuania)"
    },
    %{
      code: "lv-LV",
      country: "LV",
      name: "Latvian (Latvia)"
    },
    %{
      code: "mi-NZ",
      country: "NZ",
      name: "Maori (New Zealand)"
    },
    %{
      code: "mk-MK",
      country: "MK",
      name: "Macedonian (Former Yugoslav Republic of Macedonia)"
    },
    %{
      code: "mn-MN",
      country: "MN",
      name: "Mongolian (Cyrillic, Mongolia)"
    },
    %{
      code: "mr-IN",
      country: "IN",
      name: "Marathi (India)"
    },
    %{
      code: "ms-BN",
      country: "BN",
      name: "Malay (Brunei Darussalam)"
    },
    %{
      code: "ms-MY",
      country: "MY",
      name: "Malay (Malaysia)"
    },
    %{
      code: "mt-MT",
      country: "MT",
      name: "Maltese (Malta)"
    },
    %{
      code: "nb-NO",
      country: "NO",
      name: "Norwegian, Bokmal (Norway)"
    },
    %{
      code: "nl-BE",
      country: "BE",
      name: "Dutch (Belgium)"
    },
    %{
      code: "nl-NL",
      country: "NL",
      name: "Dutch (Netherlands)"
    },
    %{
      code: "nn-NO",
      country: "NO",
      name: "Norwegian, Nynorsk (Norway)"
    },
    %{
      code: "ns-ZA",
      country: "ZA",
      name: "Northern Sotho (South Africa)"
    },
    %{
      code: "pa-IN",
      country: "IN",
      name: "Punjabi (India)"
    },
    %{
      code: "pl-PL",
      country: "PL",
      name: "Polish (Poland)"
    },
    %{
      code: "pt-BR",
      country: "BR",
      name: "Portuguese (Brazil)"
    },
    %{
      code: "pt-PT",
      country: "PT",
      name: "Portuguese (Portugal)"
    },
    %{
      code: "quz-BO",
      country: "BO",
      name: "Quechua (Bolivia)"
    },
    %{
      code: "quz-EC",
      country: "EC",
      name: "Quechua (Ecuador)"
    },
    %{
      code: "quz-PE",
      country: "PE",
      name: "Quechua (Peru)"
    },
    %{
      code: "ro-RO",
      country: "RO",
      name: "Romanian (Romania)"
    },
    %{
      code: "ru-RU",
      country: "RU",
      name: "Russian (Russia)"
    },
    %{
      code: "sa-IN",
      country: "IN",
      name: "Sanskrit (India)"
    },
    %{
      code: "se-FI",
      country: "FI",
      name: "Sami (Northern) (Finland)"
    },
    %{
      code: "se-NO",
      country: "NO",
      name: "Sami (Northern) (Norway)"
    },
    %{
      code: "se-SE",
      country: "SE",
      name: "Sami (Northern) (Sweden)"
    },
    %{
      code: "sk-SK",
      country: "SK",
      name: "Slovak (Slovakia)"
    },
    %{
      code: "sl-SI",
      country: "SI",
      name: "Slovenian (Slovenia)"
    },
    %{
      code: "sma-NO",
      country: "NO",
      name: "Sami (Southern) (Norway)"
    },
    %{
      code: "sma-SE",
      country: "SE",
      name: "Sami (Southern) (Sweden)"
    },
    %{
      code: "smj-NO",
      country: "NO",
      name: "Sami (Lule) (Norway)"
    },
    %{
      code: "smj-SE",
      country: "SE",
      name: "Sami (Lule) (Sweden)"
    },
    %{
      code: "smn-FI",
      country: "FI",
      name: "Sami (Inari) (Finland)"
    },
    %{
      code: "sms-FI",
      country: "FI",
      name: "Sami (Skolt) (Finland)"
    },
    %{
      code: "sq-AL",
      country: "AL",
      name: "Albanian (Albania)"
    },
    %{
      code: "sr-Cyrl-BA",
      country: "BA",
      name: "Serbian (Cyrillic) (Bosnia and Herzegovina)"
    },
    %{
      code: "sr-Cyrl-CS",
      country: "CS",
      name: "Serbian (Cyrillic, Serbia)"
    },
    %{
      code: "sr-Latn-BA",
      country: "BA",
      name: "Serbian (Latin) (Bosnia and Herzegovina)"
    },
    %{
      code: "sr-Latn-CS",
      country: "CS",
      name: "Serbian (Latin, Serbia)"
    },
    %{
      code: "sv-FI",
      country: "FI",
      name: "Swedish (Finland)"
    },
    %{
      code: "sv-SE",
      country: "SE",
      name: "Swedish (Sweden)"
    },
    %{
      code: "sw-KE",
      country: "KE",
      name: "Kiswahili (Kenya)"
    },
    %{
      code: "syr-SY",
      country: "SY",
      name: "Syriac"
    },
    %{
      code: "syr-SY",
      country: "SY",
      name: "Syriac (Syria)"
    },
    %{
      code: "ta-IN",
      country: "IN",
      name: "Tamil (India)"
    },
    %{
      code: "te-IN",
      country: "IN",
      name: "Telugu (India)"
    },
    %{
      code: "th-TH",
      country: "TH",
      name: "Thai (Thailand)"
    },
    %{
      code: "tn-ZA",
      country: "ZA",
      name: "Tswana (South Africa)"
    },
    %{
      code: "tr-TR",
      country: "TR",
      name: "Turkish (Turkey)"
    },
    %{
      code: "tt-RU",
      country: "RU",
      name: "Tatar (Russia)"
    },
    %{
      code: "uk-UA",
      country: "UA",
      name: "Ukrainian (Ukraine)"
    },
    %{
      code: "ur-PK",
      country: "PK",
      name: "Urdu (Islamic Republic of Pakistan)"
    },
    %{
      code: "uz-Cyrl-UZ",
      country: "UZ",
      name: "Uzbek (Cyrillic, Uzbekistan)"
    },
    %{
      code: "uz-Latn-UZ",
      country: "UZ",
      name: "Uzbek (Latin, Uzbekistan)"
    },
    %{
      code: "vi-VN",
      country: "VN",
      name: "Vietnamese (Vietnam)"
    },
    %{
      code: "xh-ZA",
      country: "ZA",
      name: "Xhosa (South Africa)"
    },
    %{
      code: "zh-CN",
      country: "CN",
      name: "Chinese (People's Republic of China)"
    },
    %{
      code: "zh-HK",
      country: "HK",
      name: "Chinese (Hong Kong S.A.R.)"
    },
    %{
      code: "zh-MO",
      country: "MO",
      name: "Chinese (Macao S.A.R.)"
    },
    %{
      code: "zh-SG",
      country: "SG",
      name: "Chinese (Singapore)"
    },
    %{
      code: "zh-TW",
      country: "TW",
      name: "Chinese (Taiwan)"
    },
    %{
      code: "zu-ZA",
      country: "ZA",
      name: "Zulu (South Africa)"
    }
  ]

  @doc """
  Find ONE property of value in @list
  """
  def find(property, value) when is_atom(property) do
    @list
    |> Enum.find(@list, fn p -> p[property] == to_string(value) end)

    # |> Enum.into(__MODULE__)
  end

  @doc """
  Return all languages
  """
  def all(), do: @list
end
