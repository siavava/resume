// Curriculum Vitæ — document structure only.
//
// All content lives in the shared data source (../data.yaml); all styling
// lives in template.typ; the data→content mapping lives in render.typ. To
// rebuild this CV for someone else, edit only data.yaml. Build with `make`
// (which sets the project root to the repo so /data.yaml resolves).

#import "template.typ": *
#import "render.typ": *

#let data = yaml("/data.yaml")

#show: cv

#section[I][Personal information]
#render-personal(data.personal)

#section[II][Education]
#render-education(data.education)

#section[III][Professional experience]
#render-experience(data.experience)

#section[IV][Teaching experience]
#render-teaching(data.teaching)

#section[V][Publications]
#render-publications(data.publications)

#section[VI][Technical skills]
#render-skills(data.skills)

#section[VII][Other information]
#render-other(data.at("other-information"))
