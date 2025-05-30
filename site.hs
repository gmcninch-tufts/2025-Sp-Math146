--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Text.Pandoc
--------------------------------------------------------------------------------


mathjaxExtensions :: Extensions
mathjaxExtensions = extensionsFromList 
                    [Ext_tex_math_dollars --  $...$ or $$...$$
                    ,Ext_tex_math_double_backslash --  \(...\) or \[...\]
                    ,Ext_latex_macros
                    ,Ext_inline_code_attributes 
                    ]
readMathjaxOptions :: ReaderOptions 
readMathjaxOptions = defaultHakyllReaderOptions
                {
                    readerExtensions = readerExtensions defaultHakyllReaderOptions <> mathjaxExtensions
                }
writeMathjaxOptions :: WriterOptions
writeMathjaxOptions = defaultHakyllWriterOptions 
                {
                    writerHTMLMathMethod = MathJax ""
                }
mathJaxAddedCompiler :: Compiler (Item String)
mathJaxAddedCompiler = pandocCompilerWith readMathjaxOptions writeMathjaxOptions


main :: IO ()
main = hakyllWith config $ do
    match "course-assets/**" $ do
        route   idRoute
        compile copyFileCompiler


    match "course-content/*assets" $ do
        route   idRoute
        compile copyFileCompiler

    match ("course-assignments/*md"
          .||. "course-content/*md"
          )$ do
        route $ setExtension "html"
        compile $ mathJaxAddedCompiler
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls

    match "course-assignments/*pdf"
          $ do
      route idRoute
      compile copyFileCompiler

    match "course-content/*pdf"
          $ do
      route idRoute
      compile copyFileCompiler


    match (fromList ["about.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls


    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "course-pages/*pdf" $ do
      route idRoute
      compile copyFileCompiler

    match "course-pages/*md" $ do
        route $ setExtension "html"
        compile $ mathJaxAddedCompiler
            >>= loadAndApplyTemplate "templates/page.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls


    match "course-posts/*md" $ do
        route $ setExtension "html"
        compile $ mathJaxAddedCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "course-posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Post archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls



    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- fmap (take 10) $ recentFirst =<< loadAll "course-posts/*"

            
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    -- dateField "date" "%B %e, %Y" `mappend`
    dateField "date" "%Y-%m-%d" `mappend`
    defaultContext


-- postCtxWithTags :: Tags -> Context String
-- postCtxWithTags tags = tagsField "tags" tags `mappend` postCtx


config :: Configuration
config = defaultConfiguration
  { destinationDirectory = "/home/george/Prof-VC/classes/2025-Sp-Math146/docs"
  , providerDirectory    = "/home/george/Prof-VC/classes/2025-Sp-Math146"
  , storeDirectory       = "/home/george/Prof-VC/classes/2025-Sp-Math146/_cache"
  , tmpDirectory         = "/home/george/Prof-VC/classes/2025-Sp-Math146/_cache/tmp"  
  , previewPort          = 9090
  , deployCommand        = "bash /home/george/Prof-VC/classes/2025-Sp-Math146/deploy.sh"
  }
