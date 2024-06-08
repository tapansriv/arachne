
# from mvlearn.embed import KMCCA
# from mvlearn.model_selection import train_test_split
# from mvlearn.plotting import crossviews_plot


# X_test, y_test, keys = generate_features_and_labels(
#                              clean_dict_keys(args.test_runtimes_file),
#                              args.test_plan_dir)
# kmcca = KMCCA(
#     kernel="rbf", kernel_params={'gamma': 1}, n_components=1, regs=0.01)
# kmcca.fit([X_train, y_train.reshape(-1, 1)])
# scores = kmcca.transform([X_test, y_test.reshape(-1,1)])
# print(scores.shape)
# print(scores.reshape(2,99))
# crossviews_plot(scores, ax_ticks=True, ax_labels=True, equal_axes=True,
#         title='Scores crossplot: Gaussian KMCCA')

