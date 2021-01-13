//
//  ExploreViewController.swift
//  TikTok
//
//  Created by Michael Kang on 1/7/21.
//

import UIKit


class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search..."
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()
    
    private var sections = [ExploreSection]()
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureModels()
        setUpSearchBar()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func configureModels() {
        // configure the section
        var cells = [ExploreCells]()
        for _ in 0...100 {
            let cell = ExploreCells.banner(
                viewModel: ExploreBannerViewModel(
                    imageView: nil,
                    title: "Foo",
                    handler: {
                        
                    })
            )
            cells.append(cell)
        }
        // Banner
        sections.append(ExploreSection(type: .banners, cells: cells))
        // trending posts
        var posts = [ExploreCells]()
        for _ in 0...1000 {
            let post = ExploreCells.post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            ))
            posts.append(post)
        }
        sections.append(ExploreSection(type: .trendingPosts, cells: posts))
        // users
        sections.append(ExploreSection(type: .users, cells: [
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            }))
        ]))
        // trending hashtags
        sections.append(ExploreSection(type: .trendingHastags, cells: [
            .hashtag(viewModel: ExploreHashtagViewModel(text: "#foryou", icon: nil, count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "#foryou", icon: nil, count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "#foryou", icon: nil, count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "#foryou", icon: nil, count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "#foryou", icon: nil, count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "#foryou", icon: nil, count: 1, handler: {
                
            })),
        ]))
        // recommended
        sections.append(ExploreSection(type: .recommended, cells: [
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            ))
        ]))
        // popular
        sections.append(ExploreSection(type: .popular, cells: [
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            ))
        ]))
        // new
        sections.append(ExploreSection(type: .new, cells: [
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            )),
            .post(viewModel: ExplorePostViewModel(
                thumbnail: nil, caption: "", handler: {
                    
                }
            ))
        ]))
    }
    
    func setUpSearchBar(){
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func setUpCollectionView(){
        let layout = UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            // return layout for every section
            // with a different function
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
        
    }
    
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        
        switch sectionType {
        case .banners:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 4, leading: 4, bottom: 4, trailing: 4)
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.90),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging // what is the scrolling behaviour you want
            // Return
            return sectionLayout
        case .trendingHastags:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 4, leading: 4, bottom: 4, trailing: 4)
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60) // should be the height of each cell multiplied by count
                ),
                subitems: [item]
            )
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            //sectionLayout.orthogonalScrollingBehavior = .groupPaging // what is the scrolling behaviour you want
            // becuase it is not scrollable (horizontally) the more hastags will push the page down
            // Return
            return sectionLayout
        case .users:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 4, leading: 4, bottom: 4, trailing: 4)
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging // what is the scrolling behaviour you want
            // Return
            return sectionLayout
        case .trendingPosts,.recommended, .new:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 4, leading: 4, bottom: 4, trailing: 0)
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(240)
                ),
                subitem: item,
                count: 2
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(106), heightDimension: .absolute(240)), subitems: [verticalGroup])
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous // what is the scrolling behaviour you want
            // Return
            return sectionLayout
        case .popular:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 4, leading: 4, bottom: 4, trailing: 0)
            // Group

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(106), heightDimension: .absolute(200)), subitems: [item])
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous // what is the scrolling behaviour you want
            // Return
            return sectionLayout
        }
    }
    
}

extension ExploreViewController: UISearchBarDelegate {
    
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        let model = sections[indexPath.section].cells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
}
