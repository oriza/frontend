// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import {
  differenceInHours,
  differenceInDays,
  isYesterday,
  differenceInMonths,
  distanceInWordsStrict,
  format
} from 'date-fns'
import hu from 'date-fns/locale/hu'

const articleList = document.querySelector('.articles')
const siteCheckboxes = Array.from(document.querySelectorAll('.site input'))
const categoryCheckboxes = Array.from(document.querySelectorAll('.category input'))
const loadMoreButton = document.querySelector('.load-more')

function getSelectedSites () {
  const selectedSitesFromCookies = getCookie('sites')

  if (!selectedSitesFromCookies) {
    const selectedSites = checkboxesToParams('sites', siteCheckboxes)
    document.cookie = selectedSites.split(',').join('.')
  }
}

function getCookie (name) {
  const match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'))
  
  if (match) {
    return match[2]
  }
}

function checkboxesToParams (name, checkboxes) {
    const ids = checkboxes
      .filter(input => input.checked)
      .map(input => input.value)
    
    return `${name}=${ids.join(',')}`
}

function updateArticles (_event, isLoadMore = false) {
  const siteParams = checkboxesToParams('sites', siteCheckboxes)
  const categoryParams = checkboxesToParams('categories', categoryCheckboxes)
  const lastArticle = document.querySelector('.article:last-of-type time')
  const lastArticlesDateTime = lastArticle ? lastArticle.getAttribute('datetime') : new Date()

  document.cookie = siteParams.split(',').join('.')

  const till = isLoadMore ? lastArticlesDateTime : ''

  fetch(`/api/articles?${siteParams}&${categoryParams}&till=${till}`)
    .then(response => response.json())
    .then(articles => renderArticles(articles, isLoadMore))
    .catch(renderError)
}

function renderArticles ({articles}, isLoadMore) {
  if (!isLoadMore) {
    articleList.innerHTML = ''
  }

  articles.map(article => {
    const articleElement = document.createElement('li')
    articleElement.classList.add('article')
    articleElement.innerHTML = `
      <header class="inline">
          <time datetime="${article.published_at}">${formatDatetime(article.published_at)}</time>        
          <a href="#">
            <img class="logo-${article.site.slug}" src="images/sites/${article.site.slug}.png" alt="${article.site.name} logó" />
          </a>
      </header>
      <h2>
        <a href=${article.url} target="_blank" rel="noopener">
          ${article.title}
        </a>
      </h2>
      <p>${truncate(article.description)}</p>
    `

    articleList.appendChild(articleElement)
  })
}

function renderError (error) {
  console.log(error.message)
}

function truncate (text) {
  if (text.length > 255) {
    return text.substring(0, 250) + '...'
  }

  return text
}

function formatDatetime (datetime) {
  if (!datetime) return ''

  if (differenceInMonths(new Date(), datetime) > 0) {
    return format(datetime, 'YYYY MMMM DD', {locale: hu})
  } else if (isYesterday(datetime) || differenceInDays(new Date(), datetime) > 0) {
    return format(datetime, 'MMMM DD', {locale: hu})
  } else if (differenceInHours(new Date(), datetime) > 0) {
    return format(datetime, 'HH:mm', {locale: hu})
  } else {
    return distanceInWordsStrict(new Date(), datetime, {locale: hu})
  }
}

getSelectedSites()

siteCheckboxes.forEach(checkbox => checkbox.addEventListener('change', updateArticles))
categoryCheckboxes.forEach(checkbox => checkbox.addEventListener('change', updateArticles))
loadMoreButton.addEventListener('click', event => updateArticles(event, true))
